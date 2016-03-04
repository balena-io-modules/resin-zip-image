###
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
###

Promise = require('bluebird')
fs = require('fs')
path = require('path')
unzip = require('unzip2')

###*
# @summary Extract a file from a zip archive
# @function
# @public
#
# @param {String} zip - zip file path
# @param {String} file - file to extract
# @fulfil {ReadableStream} - file stream
# @returns {Promise}
#
# @example
# utils.extractFile('path/to/archive.zip', 'resin.img').then (stream) ->
#   stream.pipe(fs.createWriteStream('output.img'))
###
exports.extractFile = (zip, file) ->
	return new Promise (resolve, reject) ->
		fs.createReadStream(zip)
			.pipe(unzip.Parse())
			.on('error', reject)
			.on 'entry', (entry) ->
				if entry.type is 'File' and path.basename(entry.path) is file
					return resolve(entry)

				entry.autodrain()
