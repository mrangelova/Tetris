module Tetris
  module GUI
    module Configs
      LIVE_CELL_IMAGE_PATH     = File.join(File.dirname(__FILE__), '..', 'media', 'live_cell.png')
      DEFAULT_CELL_IMAGE_PATH  = File.join(File.dirname(__FILE__), '..', 'media', 'default_cell.png')
      OCCUPIED_CELL_IMAGE_PATH = File.join(File.dirname(__FILE__), '..', 'media', 'occupied_cell.png')
      GAME_OVER_SOUND_PATH     = File.join(File.dirname(__FILE__), '..', 'media', 'end.wav')
      GAME_MUSIC_PATH          = File.join(File.dirname(__FILE__), '..', 'media', 'play.ogg')
    end
  end
end