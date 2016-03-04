
/*
Copyright 2016 Resin.io

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	 http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 */

/**
 * @module zip
 */
var AdmZip, IMAGE_FORMATS, path, utils, _;

_ = require('lodash');

path = require('path');

AdmZip = require('adm-zip');

utils = require('./utils');

IMAGE_FORMATS = ['.iso', '.img'];


/**
 * @summary Get Zip image entries
 * @function
 * @public
 *
 * @description
 * This function returns an array of objects that represent
 * the "image" files found in the zip archive.
 *
 * @param {String} zip - zip file path
 * @returns {Object[]} image entries
 *
 * @throws Will throw if the zip is not a zip archive
 *
 * @example
 * zipImage = require('resin-zip-image')
 *
 * imageEntries = zipImage.getImageEntries('path/to/archive.zip')
 *
 * imageEntries.forEach (imageEntry) ->
 *   console.log(imageEntry.name)
 *   console.log(imageEntry.size)
 */

exports.getImageEntries = function(zip) {
  var admZip;
  if (!utils.isZip(zip)) {
    throw new Error('Invalid zip image');
  }
  admZip = new AdmZip(zip);
  return _.chain(admZip.getEntries()).filter(function(entry) {
    return _.includes(IMAGE_FORMATS, path.extname(entry.name));
  }).map(function(entry) {
    return {
      name: entry.name,
      size: entry.header.size
    };
  }).value();
};


/**
 * @summary Check if a Zip is a Zip image
 * @function
 * @public
 *
 * @description
 * A Zip is considered a Zip image if it contains only one
 * `*.iso` or `*.img` file.
 *
 * It is still considered valid if it contains an image file
 * and many other non-image files.
 *
 * @param {String} zip - zip file path
 * @returns {Boolean} whether the zip is a zip image
 *
 * @example
 * zipImage = require('resin-zip-image')
 *
 * if zipImage.isValidZipImage('path/to/archive.zip')
 *   console.log('This is a Zip image!')
 */

exports.isValidZipImage = function(zip) {
  return utils.isZip(zip) && exports.getImageEntries(zip).length === 1;
};


/**
 * @summary Extract the image file from a Zip image
 * @function
 * @public
 *
 * @param {String} zip - zip file path
 * @fulfil {ReadableStream} - image file
 * @returns {Promise}
 *
 * @throws Will throw if the zip is not a zip image
 *
 * @example
 * zipImage = require('resin-zip-image')
 *
 * zipImage.extractImage('path/to/archive.zip').then (stream) ->
 *   stream.pipe(fs.createWriteStream('output.img'))
 */

exports.extractImage = function(zip) {
  var imageEntry;
  if (!exports.isValidZipImage(zip)) {
    throw new Error('Invalid zip image');
  }
  imageEntry = _.first(exports.getImageEntries(zip));
  return utils.extractFile(zip, imageEntry.name).tap(function(stream) {
    return stream.length = imageEntry.size;
  });
};
