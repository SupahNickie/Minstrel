class PlaylistsController < ApplicationController
  before_filter :set_user
  before_action :set_playlist, only: [:show, :edit, :update, :destroy, :whitelist, :blacklist, :unblacklist]

  # GET /playlists
  # GET /playlists.json
  def index
    @playlists = @user.playlists.all
  end

  # GET /playlists/1
  # GET /playlists/1.json
  def show
    @songs = Song.all
    @playlist.find_music(@playlist, @songs, @playlist.mood, @playlist.timbre, @playlist.intensity, @playlist.tone)
  end

  # GET /playlists/new
  def new
    @playlist = @user.playlists.new
  end

  # GET /playlists/1/edit
  def edit
  end

  # POST /playlists
  # POST /playlists.json
  def create
    @playlist = @user.playlists.new(playlist_params)

    respond_to do |format|
      if @playlist.save
        format.html { redirect_to user_playlists_path(@user), notice: 'Playlist was successfully created.' }
        format.json { render action: 'show', status: :created, location: @playlist }
      else
        format.html { render action: 'new' }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /playlists/1
  # PATCH/PUT /playlists/1.json
  def update
    respond_to do |format|
      if @playlist.update(playlist_params)
        format.html { redirect_to user_playlists_path(@user), notice: 'Playlist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playlists/1
  # DELETE /playlists/1.json
  def destroy
    @playlist.destroy
    respond_to do |format|
      format.html { redirect_to user_playlists_path(@user) }
      format.json { head :no_content }
    end
  end

  def whitelist
    @song = Song.find(params[:song_id])
    @playlist.change_whitelist(@playlist, @song, "add")
    respond_to do |format|
      format.html { redirect_to user_playlist_path(@user, @playlist), notice: 'Song was successfully favorited to this playlist!' }
      format.json { head :no_content }
      format.js
    end
  end

  def blacklist
    @song = Song.find(params[:song_id])
    @playlist.change_whitelist(@playlist, @song, "remove")
    respond_to do |format|
      format.html { redirect_to user_playlist_path(@user, @playlist), notice: 'Song was successfully removed from this playlist.'}
      format.json { head :no_content }
      format.js
    end
  end

  def unblacklist
    @song = Song.find(params[:song_id])
    @playlist.change_whitelist(@playlist, @song, "unblacklist")
    respond_to do |format|
      format.html { redirect_to user_playlist_path(@user, @playlist), notice: 'Song was successfully given another chance!' }
      format.json { head :no_content }
      format.js
    end
  end

  def view_blacklist
    @playlist = @user.playlists.find(params[:playlist_id])
  end

  private

    def set_user
      @user = User.find(params[:user_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
      @playlist = @user.playlists.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def playlist_params
      params.require(:playlist).permit(:name, :mood, :timbre, :intensity, :tone, :songs_list, :user_id, :whitelist, :blacklist)
    end
end
