class MicropostsController < ApplicationController
    before_action :only_loggedin_users, only: [:create, :destroy]

    def create
        @micropost = current_user.microposts.build(micropost_params)
        @micropost.image.attach(params[:micropost][:image])
        if @micropost.save
            flash[:success] = "Post created!"
            redirect_to root_url
        else
            @feed_items = []
            flash[:danger] = "Post Failed! or file attached isn't an image"
            redirect_to root_url
        end
    end

    def destroy
        Micropost.find(params[:id]).destroy
        flash[:danger] = "Post Deleted!"
        redirect_to root_url
    end

    def like
        @micropost = Micropost.find(params[:id])
        @micropost.likes.create
    
        redirect_back(fallback_location: root_path)
    end

    def dislike
        @micropost = Micropost.find(params[:id])
        @micropost.likes.first.destroy
    
        redirect_back(fallback_location: root_path)
    end

    private
    def micropost_params
        params.require(:micropost).permit(:content, :image)
    end

    def correct_user
        @micropost = current_user.microposts.find_by(id: params[:id])
        redirect_to root_url
    end

end
