class NotesController < ApplicationController
  before_action :authenticate_user!, except: [ :leaderboard ]
  before_action :set_note, only: [ :edit, :update, :destroy ]

  def index
    @active_notes = current_user.notes.where(archived: false)
    @archived_notes = current_user.notes.where(archived: true)
    @points = current_user.notes.where(archived: true, completed: true)

    @note = Note.new
    @user = current_user
  end

  def new
    @note = current_user.notes.build
  end

  def create
    @note = current_user.notes.build(note_params)
    @note.owner = current_user

    if @note.save
      @note.users << current_user unless @note.users.include?(current_user) # Add to collaborators
      redirect_to notes_path, notice: "Note created successfully."
    else
      flash.now[:alert] = "Note creation failed."
      render :index, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @note.update(note_params)
      redirect_to notes_path, notice: "Note updated successfully."
    else
      render :edit
    end
  end

  def archive
    note = Note.find(params[:id])
    note.update(archived: true)
    redirect_to notes_path, notice: "Note deleted successfully."
  end

  def destroy
    @note.destroy
    redirect_to notes_path, notice: "Note deleted successfully."
  end

  def leaderboard
    @leaderboard = User.leaderboard(10)
  end

  private

  def set_note
    @note = current_user.notes.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :content, :deadline, :completed, :penalty_enabled)
  end
end
