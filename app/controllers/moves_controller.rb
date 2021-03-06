class MovesController < ApplicationController
  before_action :set_move, only: [:show, :destroy, :update, :edit, :rooms_list, :add_stuffs, :recap, :details]
  before_action :set_user, only: [:new, :create]
  before_action :set_room, only: [:add_stuffs]

  # method crud
  def index
  end

  def new
    @move = Move.new
  end

  def create
    @move = Move.new(move_params)
    @move.user = @user
    if @move.save
      # redirection vers la page
      redirect_to add_rooms_move_path(@move)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @move.update(move_params)
      redirect_to @move
    else
      render :edit
    end
  end

  def destroy
    @move.destroy
    redirect_to root_path
  end

  # method perso evaluat3d

  def add_rooms
  end

  def create_rooms
  end

  def rooms_list
    @rooms = @move.rooms
  end

  def add_stuffs
    @stuffs = @room.room_type.stuffs
  end

  def create_stuffs
  end

  def recap
    rooms_list
    @recap = {}
    @rooms.each do |room|
      @recap[room.name] = strip_trailing_zero(volume_stuffs(set_stuffs(room)))
    end
    @volume_total = strip_trailing_zero(volume_total)
  end

  def details
    rooms_list
    total_cartons(@rooms)
    @volume_total = strip_trailing_zero(volume_total)
  end

  def find_mover
  end

  private

  def move_params
    params.require(:move).permit(:depart, :arrivee, :house_type, :acces, :transport, :user_id)
  end

  def set_move
    if params[:move_id].nil?
      @move = Move.find(params[:id])
    else
      @move = Move.find(params[:move_id])
    end
  end

  def set_user
    @user = current_user
  end

  def set_room
    @room = Room.find(params[:id])
  end

  def set_stuffs(room)
    room.stuffs
  end

  def volume_stuffs(stuffs)
    sum = 0
    stuffs.each do |stuff|
      sum += stuff.volume.to_f
      unless stuff.volume_carton.nil?
        sum += stuff.volume_carton.to_f
      end
    end
    sum
  end

  def volume_total
    unless @rooms.nil?
      sum = 0
      @rooms.each do |room|
        sum += volume_stuffs(set_stuffs(room))
      end
      sum
    end
  end

  def total_cartons(rooms)
    cartons = 0
    rooms.each do |room|
      set_stuffs(room).each do |stuff|
        cartons += stuff.carton
      end
    end
    @cartons = cartons
  end

  def strip_trailing_zero(number)
    number.to_s.sub(/\.?0+$/, '')
  end
end
