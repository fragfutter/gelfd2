require 'gelfd2/version'

module Gelfd2
  CHUNKED_MAGIC = [0x1e, 0x0f].pack('C*').freeze
  # zlib header is defined in https://www.rfc-editor.org/rfc/rfc1950#page-4
  # and a bit complicated to detect.
  # stackoverflow https://stackoverflow.com/a/54915442
  #   It contains these bitfields from most to least significant:
  # 
  # CINFO (bits 12-15, first byte)
  # Indicates the window size as a power of two, from 0 (256 bytes) to 7 (32768
  # bytes). This will usually be 7. Higher values are not allowed.
  # 
  # CM (bits 8-11)
  # The compression method. Only Deflate (8) is allowed.
  # 
  # FLEVEL (bits 6-7, second byte)
  # Roughly indicates the compression level, from 0 (fast/low) to 3 (slow/high)
  # 
  # FDICT (bit 5)
  # Indicates whether a preset dictionary is used. This is usually 0. (1 is
  # technically allowed, but I don't know of any Deflate formats that define
  # preset dictionaries.)
  # 
  # FCHECK (bits 0-4)
  # A checksum (5 bits, 0..31), whose value is calculated such that the entire
  # value divides 31 with no remainder.*
  # 
  # Typically, only the CINFO and FLEVEL fields can be freely changed, and
  # FCHECK must be calculated based on the final value. Assuming no preset
  # dictionary, there is no choice in what the other fields contain, so a total
  # of 32 possible headers are valid. Here they are:
  # 
  #       FLEVEL: 0       1       2       3
  # CINFO:
  #      0      08 1D   08 5B   08 99   08 D7
  #      1      18 19   18 57   18 95   18 D3
  #      2      28 15   28 53   28 91   28 CF
  #      3      38 11   38 4F   38 8D   38 CB
  #      4      48 0D   48 4B   48 89   48 C7
  #      5      58 09   58 47   58 85   58 C3
  #      6      68 05   68 43   68 81   68 DE
  #      7      78 01   78 5E   78 9C   78 DA
  #
  # The CINFO field is rarely, if ever, set by compressors to be anything other
  # than 7 (indicating the maximum 32KB window), so the only values you are
  # likely to see in the wild are the four in the bottom row (beginning with
  # 78).
  ZLIB_MAGIC_0 = [0x78, 0x01].pack('C*').freeze
  ZLIB_MAGIC_1 = [0x78, 0x5e].pack('C*').freeze
  ZLIB_MAGIC_2 = [0x78, 0x9c].pack('C*').freeze
  ZLIB_MAGIC_3 = [0x78, 0xda].pack('C*').freeze
  GZIP_MAGIC = [0x1f, 0x8b].pack('C*').freeze
  UNCOMPRESSED_MAGIC = [0x1f, 0x3c].pack('C*').freeze
  HEADER_LENGTH = 12
  DATA_LENGTH = 8192 - HEADER_LENGTH
  MAX_CHUNKS = 128
end

require File.join(File.dirname(__FILE__), 'gelfd2', 'exceptions')
require File.join(File.dirname(__FILE__), 'gelfd2', 'zlib_parser')
require File.join(File.dirname(__FILE__), 'gelfd2', 'gzip_parser')
require File.join(File.dirname(__FILE__), 'gelfd2', 'chunked_parser')
require File.join(File.dirname(__FILE__), 'gelfd2', 'parser')
