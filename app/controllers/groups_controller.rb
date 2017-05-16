class GroupsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :update, :destroy]
  before_action :find_group_and_check_permission, only: [:edit, :update, :destroy]
  before_action :find_group, only: [ :edit, :update, :detroy]
  def index
    @groups = Group.all.recentt
  end

  def new
    @group = Group.new
  end

  def create
    # @group = Group.new(group_params)
    @group = current_user.groups.new(group_params)
    @group.user = current_user
    if @group.save
      current_user.join!(@group)
      redirect_to groups_path
    else
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])
    # @posts = @group.posts.order("created_at DESC")
    @posts = @group.posts.recent.paginate(page: params[:page], per_page: 5)
    
  end

  def edit
    # find_group_and_check_permission
    # @group = Group.find(params[:id])
    # if current_user != @group.user
    #   redirect_to root_path, alert: "You have no permission"
    # end
  end

  def update
    # find_group_and_check_permission
    # @group = Group.find(params[:id])
    # if current_user != @group.user
    #   redirect_to root_path, alert: "You have no permission"
    # end
    if @group.update(group_params)
      redirect_to groups_path, notice: "Update Success"
    else
      render :edit
    end
  end

  def destroy
    # find_group_and_check_permission
    # @group = Group.find(params[:id])
    # if current_user != @group.user
    #   redirect_to root_path, alert: "You have no permission"
    # end
    @group.destroy
    flash[:alert] = "Group deleted"
    redirect_to groups_path
    #redirect_to groups_path, alert: "Group deleted"
  end

  def join
    @group = Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "Join this Group success"
    else
      flash[:warning] = "U are already in this Group!"
    end

    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])

    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "U Quit this Group"
    else
      flash[:warning] = "你本來就不是這個群組的！ 退屁！"
    end

    redirect_to group_path(@group)
  end

  private

  def find_group
    # @group = Group.find(params[:id])
    @group = current_user.groups.find(params[:id])
  end

  def find_group_and_check_permission
    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to groups_path, alert: "You have no permission!"
    end
  end

  def group_params
    params.require(:group).permit(:title, :description)
  end
end
