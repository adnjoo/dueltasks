class NotesController < ApplicationController
  before_action :authenticate_user!, except: [ :leaderboard ]
  before_action :set_note, only: [ :edit, :update, :destroy ]
  before_action :set_public_users, only: [ :index, :new, :edit ]

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
    @note = Note.find(params[:id])
    # Update collaborators using the new method in the Note model
    user_ids = (params[:note][:user_ids] || []).map(&:to_i)
    @note.update_collaborators(user_ids)

    # Update other attributes of the note
    if @note.update(note_params.except(:user_ids))
      redirect_to notes_path, notice: "Note was successfully updated."
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

  def set_public_users
    @public_users = User.where(public: true).where.not(id: current_user.id)
  end

  def note_params
    params.require(:note).permit(:title, :content, :deadline, :completed, :penalty_enabled, user_ids: [])
  end
end
