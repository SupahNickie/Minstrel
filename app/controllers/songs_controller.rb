class SongsController < ApplicationController
  before_filter :load_album_and_user, except: [:rating, :vote]
  before_action :set_song, only: [:show, :edit, :update, :destroy, :rating, :vote, :favorite, :delete_favorite]

  # GET /songs
  # GET /songs.json
  def index
    @songs = @album.songs.all
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
  end

  # GET /songs/new
  def new
    @song = @album.songs.new
    authorize @song
  end

  # GET /songs/1/edit
  def edit
    authorize @song
  end

  # POST /songs
  # POST /songs.json
  def create
    @song = @album.songs.new(song_params)
    authorize @song

    if @song.save
      @song.add_attributes_to_array(@song, params["song"]["mood"], params["song"]["timbre"], params["song"]["intensity"], params["song"]["tone"])
      @song.new_average(@song)
      respond_to do |format|
        format.html { redirect_to user_album_path(@user, @album), notice: 'Song was successfully created!' }
        format.json { render action: 'show', status: :created, location: @song }
      end
    else
      respond_to do |format|
        format.html { render action: 'new' }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    authorize @song

    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to user_album_path(@user, @album), notice: 'Song was successfully updated!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    authorize @song

    @song.mp3 = nil
    @song.destroy
    respond_to do |format|
      format.html { redirect_to user_album_path(@user, @album), notice: 'Song was successfully deleted!' }
      format.json { head :no_content }
    end
  end

  def rating
    authorize @song

    @album = @song.album
    @user = @album.band
    @playlist = current_user.playlists.find(params[:playlist_id])
  end

  def vote
    authorize @song

    @user = @song.album.band
    @playlist = current_user.playlists.find(params[:playlist_id])
    @album = @user.albums.find(params[:album_id])
    @song.add_attributes_to_array(@song, params["playlist"]["mood"], params["playlist"]["timbre"], params["playlist"]["intensity"], params["playlist"]["tone"])
    @song.new_average(@song)
    current_user.push_song_id_to_ratings_list(@song, current_user)

    respond_to do |format|
      if current_user.role == "band"
        format.html { redirect_to view_blacklist_user_playlist_path(current_user, @playlist), notice: 'Thank you for your vote!' }
      else
        format.html { redirect_to "/users/#{current_user.to_param}/playlists/#{@playlist.id}/view_blacklist"}
      end
    end
  end

  private

    def load_album_and_user
      @user = User.find(params[:user_id])
      @album = @user.albums.find(params[:album_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def song_params
      params.require(:song).permit(:title, :mp3, :link_to_purchase, :link_to_download, :average_mood, :average_timbre,
        :average_intensity, :average_tone, :mood, :timbre, :intensity, :tone, :album_id)
    end
end
