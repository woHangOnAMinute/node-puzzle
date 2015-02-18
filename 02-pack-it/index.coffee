
exports.pack = (data, cb) ->

  b = new Buffer(128)
  i = 0
  offset = 0
  passByte = ''

  while i < data.length
    if data[i]
       passByte += '1'
    else
       passByte += '0'
    if passByte.length == 8
       hexA = parseInt(passByte.substring(0,4), 2).toString(16);
       hexB = parseInt(passByte.substring(4), 2).toString(16);
       hex = '0x'+hexA+hexB
       b.writeUIntBE hex, offset, 1
       offset++
       passByte = ''
    i++
  cb null, b


exports.unpack = (buffer, cb) ->
  binaryString = ''
  i = 0
  data = []
  while i < buffer.length
    currentBuffer = buffer.readUIntBE(i, 1).toString(2)
    while currentBuffer.length < 8
      currentBuffer = '0'+currentBuffer
    binaryString += currentBuffer
    i++
  j = 0
  while j < binaryString.length
    if binaryString.charAt(j) == '1'
      data.push(true);
    else
      data.push(false);
    j++
  returnBuffer = new Buffer(data)
  cb null, data
