class SongsController < ApplicationController
  before_filter :load_album_and_user
  before_action :set_song, only: [:show, :edit, :update, :destroy]

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
  end

  # GET /songs/1/edit
  def edit
  end

  # POST /songs
  # POST /songs.json
  def create
    @song = @album.songs.new(song_params)

    respond_to do |format|
      if @song.save
        format.html { redirect_to user_album_path(@user, @album), notice: 'Song was successfully created.' }
        format.json { render action: 'show', status: :created, location: @song }
      else
        format.html { render action: 'new' }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to user_album_path(@user, @album), notice: 'Song was successfully updated.' }
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
    @song.destroy
    respond_to do |format|
      format.html { redirect_to user_album_path(@user, @album) }
      format.json { head :no_content }
    end
  end

  private

    def load_album_and_user
      @user = User.find(params[:user_id])
      @album = @user.albums.find(params[:album_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = @album.songs.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def song_params
      params.require(:song).permit(:title, :mp3, :link_to_purchase, :link_to_download, :average_mood, :average_timbre,
        :average_intensity, :average_tone, :mood, :timbre, :intensity, :tone, :album_id, :user_id)
    end
end
