### 2.0.1
  - Bug fixes
    - Fix error of can not found SECRET_KEY_BASE on worker.

### 2.0.0
  - New features
    - Add support for Media Session API.
    - Add new search page.
    - Add setting of transcode bitrate.
    - Add support for cache of transcode.
    - Add setting of allow transcode lossless format media.

  - Enhancements
    - Replce Turbolink to Turbo, and adopt Hotwire approach.
    - Add system test and increase test coverage.
    - Upgrade Stimulus to 3.0.
    - Use Standard Ruby style guide for code.
    - Upgrade Rails to 7.0.

  - Bug fixes
    - Fix wrong mime type for flac and wav formats.

### 1.3.0
  - new features
    - add sortable playlist

  - enhancements
    - update ruby to 2.7
    - update rails to 6.1
    - update stimulus to 2.0
    - update rubocop style config
    - avoid use instance variable in partial view and use full path in render

  - bug fixes
    - fix mini player position not fixed at the bottom in small screens with sort content

### 1.2.0
  - new features
    - add support for various artists album
    - add blurry album image as background on player
    - add support for set artist and album image manually

  - enhancements
    - use ITCSS structure to refactor all css code
    - replace gem rails-settings-cached with pg hstore
    - use nix to build dev environment
    - support docker multi-platform builds

  - bug fixes
    - fix redirect issue for 404 and 403 page

### 1.1.1
  - new features
    - add support for oga and wma formats 

  - enhancements
    - use wahwah to replace taglib-ruby
    - remove the environment variables required for installation 
  
### 1.1.0
  - enhancements
    - use pg full text search to replace pgroonga
    - update webpacker to 5.0
    - squash docker image size
    - use intersection observer api to replace scrollmagic on infinite scroll

  - bug fixes
    - fix issue for can not set right theme when user first login 
    - fix can not play song when use http range to send file on dev environment


### 1.0.5
  - enhancements
    - update Rails to 6.0.2
    - add page cache to boost performance 
    - refactor code for playlist
    - update node.js to 12.14.1

  - bug fixes
    - fix command not found issue for renew ssl script


**Breaking change**: Beacuse the data structure for playlist changed, you will lost all playlist data. Sorry about this.

### 1.0.4

- enhancements
  - add ssl setup use lets encrypt 

### 1.0.3

- bug fixes
  - keep pid directory on tmp to avoid puma loading error

### 1.0.2

- new features
  - add light theme support
  - fix issue #12, add opus support

- bug fixes
  - fix missing partial error when clear playlist
  - fix theme issue when user did not login
  - fix error when get image from m4a file
  - fix issue #8, use mtime and file_path to get md5hash rather than file content
  - fix style issue on radio input
  - fix issue of normal user can not see page of settings
  - fix issue of show empty image tag behind player loader when playing first song

- enhancements
  - fix server.pid issue on dev
  - update Rails to 6.0
  - fix SQL injection on serach
  - fix N+1 issues on albums ans songs page
  - use carrierwave to replace active storage
