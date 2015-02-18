fs = require 'fs'


GEO_FIELD_MIN = 0
GEO_FIELD_MAX = 1
GEO_FIELD_COUNTRY = 2


exports.ip2long = (ip) ->
  ip = ip.split '.', 4
  return +ip[0] * 16777216 + +ip[1] * 65536 + +ip[2] * 256 + +ip[3]


gindex = []
exports.load = ->
  data = fs.readFileSync "#{__dirname}/../data/geo.txt", 'utf8'
  data = data.toString().split '\n'

  for line in data when line
    line = line.split '\t'
    # GEO_FIELD_MIN, GEO_FIELD_MAX, GEO_FIELD_COUNTRY
    gindex.push [+line[0], +line[1], line[3]]
  quickSort gindex, 0, gindex.length - 1



normalize = (row) -> country: row[GEO_FIELD_COUNTRY]

quickSort = (arr, left, right) ->
  i = left
  j = right
  tmp = undefined
  pivotidx = (left + right) / 2
  pivot = parseInt(arr[pivotidx.toFixed()])

  ### partition ###

  while i <= j
    while parseInt(arr[i]) < pivot
      i++
    while parseInt(arr[j]) > pivot
      j--
    if i <= j
      tmp = arr[i]
      arr[i] = arr[j]
      arr[j] = tmp
      i++
      j--

  ### recursion ###

  if left < j
    quickSort arr, left, j
  if i < right
    quickSort arr, i, right
  arr

exports.lookup = (ip) ->
  return -1 unless ip

  find = this.ip2long ip

 # return normalize gindex[gindex.binaryIndexOf(find)]
  index = binaryIndexOf.call(gindex, find)
  if index < 0
    return null
  return normalize gindex[index]
  return null

binaryIndexOf = (searchElement) ->
  minIndex = 0
  maxIndex = @length - 1
  currentIndex = undefined
  currentElement = undefined
  resultIndex = undefined
  while minIndex <= maxIndex
    resultIndex = currentIndex = (minIndex + maxIndex) / 2 | 0
    currentElement = @[currentIndex]
    if currentElement[GEO_FIELD_MIN] < searchElement and currentElement[GEO_FIELD_MAX] < searchElement
      minIndex = currentIndex + 1
    else if currentElement[GEO_FIELD_MIN] > searchElement and currentElement[GEO_FIELD_MAX] > searchElement
      maxIndex = currentIndex - 1
    else
      return currentIndex
  -1
