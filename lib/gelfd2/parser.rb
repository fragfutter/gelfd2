module Gelfd2
  class Parser
    class << self
      def parse(data)
        header = data[0..1]
        case header
        when ZLIB_MAGIC_0, ZLIB_MAGIC_1, ZLIB_MAGIC_2, ZLIB_MAGIC_3
          ZlibParser.parse(data)
        when CHUNKED_MAGIC
          ChunkedParser.parse(data)
        when GZIP_MAGIC
          GzipParser.parse(data)
        else
          # by default assume the payload to be "raw, uncompressed" GELF, parsing will fail if it's malformed.
          data
        end
      end
    end
  end
end
