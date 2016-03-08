m = require('mochainon')
Promise = require('bluebird')
fs = Promise.promisifyAll(require('fs'))
path = require('path')
tmp = require('tmp')
rindle = require('rindle')
zipImage = require('../lib/zip')
zips = path.join(__dirname, 'zips')

describe 'Resin Zip Image', ->

	describe '.getImageEntries()', ->

		describe 'given an invalid zip archive', ->

			beforeEach ->
				@zip = path.join(zips, 'invalid.zip')

			it 'should throw an error', ->
				m.chai.expect =>
					zipImage.getImageEntries(@zip)
				.to.throw('Invalid zip image')

		describe 'given an empty zip', ->

			beforeEach ->
				@zip = path.join(zips, 'empty.zip')

			it 'should return an empty array', ->
				m.chai.expect(zipImage.getImageEntries(@zip)).to.deep.equal([])

		describe 'given a zip without images', ->

			beforeEach ->
				@zip = path.join(zips, 'no-image.zip')

			it 'should return an empty array', ->
				m.chai.expect(zipImage.getImageEntries(@zip)).to.deep.equal([])

		describe 'given a zip archive with image hidden files', ->

			beforeEach ->
				@zip = path.join(zips, 'hidden.zip')

			it 'should ignore the hidden files', ->
				m.chai.expect(zipImage.getImageEntries(@zip)).to.deep.equal [
					name: 'raspberrypi.img'
					size: 33554432
				]

		describe 'given a zip with a single image file', ->

			beforeEach ->
				@zip = path.join(zips, 'raspberrypi-only.zip')

			it 'should return a single entry', ->
				m.chai.expect(zipImage.getImageEntries(@zip)).to.have.length(1)

			it 'should return have name and size properties in the entry', ->
				entry = zipImage.getImageEntries(@zip)[0]
				m.chai.expect(entry.name).to.equal('raspberrypi.img')
				m.chai.expect(entry.size).to.equal(33554432)

		describe 'given a zip with one image file and other misc files', ->

			beforeEach ->
				@zip = path.join(zips, 'raspberrypi.zip')

			it 'should return a single entry', ->
				m.chai.expect(zipImage.getImageEntries(@zip)).to.have.length(1)

			it 'should return have name and size properties in the entry', ->
				entry = zipImage.getImageEntries(@zip)[0]
				m.chai.expect(entry.name).to.equal('raspberrypi.img')
				m.chai.expect(entry.size).to.equal(33554432)

		describe 'given a zip with two images', ->

			beforeEach ->
				@zip = path.join(zips, 'multiple-images.zip')

			it 'should return a two entries', ->
				m.chai.expect(zipImage.getImageEntries(@zip)).to.have.length(2)

	describe '.isValidZipImage()', ->

		describe 'given an invalid zip archive', ->

			beforeEach ->
				@zip = path.join(zips, 'invalid.zip')

			it 'should return false', ->
				m.chai.expect(zipImage.isValidZipImage(@zip)).to.be.false

		describe 'given an empty zip', ->

			beforeEach ->
				@zip = path.join(zips, 'empty.zip')

			it 'should return false', ->
				m.chai.expect(zipImage.isValidZipImage(@zip)).to.be.false

		describe 'given a zip without images', ->

			beforeEach ->
				@zip = path.join(zips, 'no-image.zip')

			it 'should return false', ->
				m.chai.expect(zipImage.isValidZipImage(@zip)).to.be.false

		describe 'given a zip archive with image hidden files', ->

			beforeEach ->
				@zip = path.join(zips, 'hidden.zip')

			it 'should return true', ->
				m.chai.expect(zipImage.isValidZipImage(@zip)).to.be.true

		describe 'given a zip with a single image file', ->

			beforeEach ->
				@zip = path.join(zips, 'raspberrypi-only.zip')

			it 'should return true', ->
				m.chai.expect(zipImage.isValidZipImage(@zip)).to.be.true

		describe 'given a zip with one image file and other misc files', ->

			beforeEach ->
				@zip = path.join(zips, 'raspberrypi.zip')

			it 'should return true', ->
				m.chai.expect(zipImage.isValidZipImage(@zip)).to.be.true

		describe 'given a zip with two images', ->

			beforeEach ->
				@zip = path.join(zips, 'multiple-images.zip')

			it 'should return false', ->
				m.chai.expect(zipImage.isValidZipImage(@zip)).to.be.false

	describe '.extractFile()', ->

		describe 'given an invalid zip archive', ->

			beforeEach ->
				@zip = path.join(zips, 'invalid.zip')

			it 'should throw an error', ->
				m.chai.expect =>
					zipImage.extractImage(@zip)
				.to.throw('Invalid zip image')

		describe 'given an empty zip', ->

			beforeEach ->
				@zip = path.join(zips, 'empty.zip')

			it 'should throw an error', ->
				m.chai.expect =>
					zipImage.extractImage(@zip)
				.to.throw('Invalid zip image')

		describe 'given a zip without images', ->

			beforeEach ->
				@zip = path.join(zips, 'no-image.zip')

			it 'should throw an error', ->
				m.chai.expect =>
					zipImage.extractImage(@zip)
				.to.throw('Invalid zip image')

		describe 'given a zip with a single image file', ->

			beforeEach ->
				@zip = path.join(zips, 'raspberrypi-only.zip')
				@image = path.join(zips, 'images', 'raspberrypi.img')

			it 'should be able to extract the image', (done) ->
				@timeout(10000)

				output = tmp.tmpNameSync()

				zipImage.extractImage(@zip).then (stream) ->
					return rindle.wait(stream.pipe(fs.createWriteStream(output)))
				.then =>
					Promise.props
						image: fs.readFileAsync(@image)
						output: fs.readFileAsync(output)
					.then (results) ->
						m.chai.expect(results.image).to.deep.equal(results.output)
				.finally ->
					fs.unlinkAsync(output)
				.nodeify(done)

		describe 'given a zip with one image file and other misc files', ->

			beforeEach ->
				@zip = path.join(zips, 'raspberrypi.zip')
				@image = path.join(zips, 'images', 'raspberrypi.img')

			it 'should be able to extract the image', (done) ->
				output = tmp.tmpNameSync()

				zipImage.extractImage(@zip).then (stream) ->
					return rindle.wait(stream.pipe(fs.createWriteStream(output)))
				.then =>
					Promise.props
						image: fs.readFileAsync(@image)
						output: fs.readFileAsync(output)
					.then (results) ->
						m.chai.expect(results.image).to.deep.equal(results.output)
				.finally ->
					fs.unlinkAsync(output)
				.nodeify(done)

		describe 'given a zip with two images', ->

			beforeEach ->
				@zip = path.join(zips, 'multiple-images.zip')

			it 'should throw an error', ->
				m.chai.expect =>
					zipImage.extractImage(@zip)
				.to.throw('Invalid zip image')

	describe '.isZip()', ->

		describe 'given an invalid zip archive', ->

			beforeEach ->
				@zip = path.join(zips, 'invalid.zip')

			it 'should return false', ->
				m.chai.expect(zipImage.isZip(@zip)).to.be.false

		describe 'given an valid zip archive', ->

			beforeEach ->
				@zip = path.join(zips, 'empty.zip')

			it 'should return true', ->
				m.chai.expect(zipImage.isZip(@zip)).to.be.true

		describe 'given a non existent file', ->

			it 'should return false', ->
				m.chai.expect(zipImage.isZip('foobarbaz.zip')).to.be.false
