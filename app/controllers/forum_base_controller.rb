class ForumBaseController < ApplicationController

  protected 
  def resource_base
    @forum = Forum.find(params[:forum_id])
  end

end
