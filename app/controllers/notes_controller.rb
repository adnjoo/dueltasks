class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, only: [ :edit, :update, :destroy ]

  def index
    @active_notes = current_user.notes.where(archived: false)
    @archived_notes = current_user.notes.where(archived: true)
  end

  def new
    @note = current_user.notes.build
  end

  def create
    @note = current_user.notes.build(note_params)
    if @note.save
      redirect_to notes_path, notice: "Note created successfully."
    else
      render :new
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
    render json: { message: "Note archived successfully" }
  end

  def destroy
    @note.destroy
    redirect_to notes_path, notice: "Note deleted successfully."
  end

  private

  def set_note
    @note = current_user.notes.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :content)
  end
end
