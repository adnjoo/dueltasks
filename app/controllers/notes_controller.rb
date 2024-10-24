class NotesController < ApplicationController
  before_action :authenticate_user!, except: [ :leaderboard ]
  before_action :set_note, only: [ :edit, :update, :destroy ]

  def index
    @active_notes = current_user.notes.where(archived: false)
    @archived_notes = current_user.notes.where(archived: true)
    @points = current_user.notes.where(archived: true, completed: true)

    @note = Note.new
  end

  def new
    @note = current_user.notes.build
  end

  def create
    @note = current_user.notes.build(note_params)
    if @note.save
      redirect_to notes_path, notice: "Note created successfully."
    else
      flash.now[:alert] = "Note creation failed."
      render :new, status: :unprocessable_entity
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

  def toggle_completion
    @note = Note.find(params[:id])
    @note.update(completed: !@note.completed)
    redirect_to notes_path, notice: "Note status updated."
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
    params.require(:note).permit(:title, :content, :deadline)
  end
end
