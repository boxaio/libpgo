/*************************************************************************
 *                                                                       *
 * Vega FEM Simulation Library Version 4.0                               *
 *                                                                       *
 * "volumetricMesh" library , Copyright (C) 2007 CMU, 2009 MIT, 2018 USC *
 * All rights reserved.                                                  *
 *                                                                       *
 * Code author: Jernej Barbic                                            *
 * http://www.jernejbarbic.com/vega                                      *
 *                                                                       *
 * Research: Jernej Barbic, Hongyi Xu, Yijing Li,                        *
 *           Danyong Zhao, Bohan Wang,                                   *
 *           Fun Shing Sin, Daniel Schroeder,                            *
 *           Doug L. James, Jovan Popovic                                *
 *                                                                       *
 * Funding: National Science Foundation, Link Foundation,                *
 *          Singapore-MIT GAMBIT Game Lab,                               *
 *          Zumberge Research and Innovation Fund at USC,                *
 *          Sloan Foundation, Okawa Foundation,                          *
 *          USC Annenberg Foundation                                     *
 *                                                                       *
 * This library is free software; you can redistribute it and/or         *
 * modify it under the terms of the BSD-style license that is            *
 * included with this library in the file LICENSE.txt                    *
 *                                                                       *
 * This library is distributed in the hope that it will be useful,       *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the file     *
 * LICENSE.TXT for more details.                                         *
 *                                                                       *
 *************************************************************************/

#include "volumetricMeshParser.h"
#include "fileIO.h"

#include <cstring>

namespace pgo
{
namespace VolumetricMeshes
{

VolumetricMeshParser::VolumetricMeshParser(const char *includeToken_)
{
  fin = nullptr;
  // fileStackDepth = -1;

  while (!fileStack.empty())
    fileStack.pop_back();

  if (includeToken_ == nullptr) {
    includeTokenLength = 9;
    strcpy(includeToken, "*INCLUDE ");
  }
  else {
    includeTokenLength = strlen(includeToken_);
    strcpy(includeToken, includeToken_);
  }
}

int VolumetricMeshParser::open(const char *filename)
{
  // extract directory name and filename
  // seek for last '/' in filename
  // if no '/', then directory name is "."
  // else, everything before '/' is directory name, and everything after is filename
  directoryName = BasicAlgorithms::getPathDirectoryName(filename);

  // now, directoryName has been extracted
  fin = fopen(filename, "r");
  if (!fin)
    return 1;

  // fileStackDepth=0;
  fileStack.push_back(fin);

  return 0;
}

VolumetricMeshParser::~VolumetricMeshParser()
{
  close();
}

void VolumetricMeshParser::rewindToStart()
{
  if (fileStack.empty())  // no files currently opened
    return;

  while (fileStack.size() > 1) {
    fclose(fileStack[fileStack.size() - 1]);
    fileStack.pop_back();
  }

  // now, we have fileStackDepth == 0
  fin = fileStack[0];
  rewind(fin);
}

void VolumetricMeshParser::close()
{
  while (fileStack.size() > 0) {
    fclose(fileStack[fileStack.size() - 1]);
    fileStack.pop_back();
  }
}

void VolumetricMeshParser::beautifyLine(char *s, int numRetainedSpaces, int removeWhitespace_)
{
  if (removeWhitespace_)
    removeWhitespace(s, numRetainedSpaces);

  // upperCase(s);

  // remove trailing '\n'
  char *pos = s;
  while (*pos != '\0')
    pos++;

  if (pos != s)  // string is not zero length
  {
    for (pos--; pos != s && std::isspace(*pos); *pos = '\0')
      ;
  }
}

char *VolumetricMeshParser::getNextLine(char *s, int numRetainedSpaces, int removeWhitespace_)
{
  char *code;
  do {
    while (((code = fgets(s, 1023, fin)) == nullptr) && (fileStack.size() > 1))  // if EOF, pop previous file from stack
    {
      fclose(fin);
      fileStack.pop_back();
      fin = fileStack[fileStack.size() - 1];
    }

    if (code == nullptr)  // reached end of main file
    {
      return nullptr;
    }
  } while ((s[0] == '#') || (s[0] == 13) || (s[0] == 10));  // ignore comments and blank lines

  beautifyLine(s, numRetainedSpaces, removeWhitespace_);

  // handle the case where input is specified via *INCLUDE
  while (strncmp(s, includeToken, includeTokenLength) == 0) {
    // open up the new file
    std::string newFile = &(s[includeTokenLength]);
    std::string newFileCompleteName = directoryName + "/" + newFile;
    FILE *finNew = fopen(newFileCompleteName.data(), "r");

    if (!finNew) {
      printf("Error: couldn't open include file %s.\n", newFileCompleteName.c_str());
      // exit(1);
      close();
      throw -1;
    }

    if ((code = fgets(s, 1023, finNew)) != nullptr)  // new file is not empty
    {
      beautifyLine(s, numRetainedSpaces, removeWhitespace_);

      // register the new file
      fileStack.push_back(finNew);
      fin = finNew;
    }
    else {
      fclose(finNew);
      printf("Warning: include file is empty.\n");
      code = getNextLine(s, numRetainedSpaces);
      beautifyLine(s, numRetainedSpaces, removeWhitespace_);
      return code;
    }
  }

  // printf("%s\n", s);

  return code;
}

// convert string to uppercase
void VolumetricMeshParser::upperCase(char *s)
{
  char caseDifference = 'A' - 'a';
  for (unsigned int i = 0; i < strlen(s); i++) {
    if ((s[i] >= 'a') && (s[i] <= 'z'))
      s[i] += caseDifference;
  }
}

// erases whitespace from string s
// retains the first "numRetainedSpaces" spaces
void VolumetricMeshParser::removeWhitespace(char *s, int numRetainedSpaces)
{
  char *p = s;
  while (*p != 0) {
    while (1) {
      bool eraseCharacter = (*p == ' ');
      for (int i = 1; i <= numRetainedSpaces; i++) {
        if (*(p + i) == 0) {
          eraseCharacter = false;
          break;
        }
        eraseCharacter = (eraseCharacter && ((p == s) || (*(p + i) == ' ')));  // always erase spaces at the beginning of line
      }

      if (!eraseCharacter)
        break;

      // erase the empty space
      char *q = p;
      while (*q != 0)   // move all subsequent characters to the left
      {
        *q = *(q + 1);  // copy the next character into the current place
        q++;
      }
    }
    p++;
  }
}

}  // namespace VolumetricMeshes
}  // namespace pgo
