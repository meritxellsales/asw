class CommentsController < ApplicationController
  # busquem a quina issue pertany el comentari
  before_action :set_issue

  def create
    @comment = @issue.comments.build(comment_params)
    # Assignem el comentari a l'usuari que ha iniciat sessió
    @comment.user = current_user 

    if @comment.save
      redirect_to @issue, notice: 'Comentari afegit correctament.'
    else
      # Si falla (ex: comentari buit), tornem a la issue
      redirect_to @issue, alert: 'No s'ha pogut guardar el comentari.'
    end
  end

  def destroy
    @comment = @issue.comments.find(params[:id])
    
    # PERMÍS: Només el creador pot esborrar el comentari
    if @comment.user == current_user
      @comment.destroy
      redirect_to @issue, notice: 'Comentari esborrat.'
    else
      redirect_to @issue, alert: 'No tens permís per esborrar aquest comentari.'
    end
  end

  private

  def set_issue
    @issue = Issue.find(params[:issue_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end