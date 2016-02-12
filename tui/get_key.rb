module Tetris
  module TUI
    module GetKey
      USE_STTY = begin
          require 'Win32API'
          KBHIT = Win32API.new('crtdll', '_kbhit', [ ], 'I')
          GETCH = Win32API.new('crtdll', '_getch', [ ], 'L')
          false
        rescue LoadError
          true
        end

      def self.getkey
        if USE_STTY
          char = nil

          begin
            system('stty raw -echo')
            char = (STDIN.read_nonblock(1).ord rescue nil)
          ensure
            system('stty -raw echo')
          end

          return char
        else
          return KBHIT.Call.zero? ? nil : GETCH.Call
        end
      end
    end
  end
end