class WorkshopsController < ApplicationController
    before_action :authorize
    before_action only: [:new, :edit, :create, :update] { authorize only: :teacher }
    before_action :set_workshop, only: [:show, :edit, :update, :destroy]

    def index
        @workshops = Workshop.all
    end

    def show
    end

    def new
        @workshop = Workshop.new
    end

    def edit
    end

    def create
        @workshop = Workshop.new workshop_params

        if @workshop.save
            flash[:success] = 'Le workshop a bien été enregistré'
            redirect_to workshops_path
        else
            flash[:error] = 'Impossible d\'enregistrer le workshop'
            render :new
        end
    end

    def update
        if @workshop.update workshop_params
            flash[:success] = 'Les modifications ont bien été enregistrées'
        else
            flash[:error] = 'Impossible d\'enregistrer les modifications'
        end

        render :edit
    end

    def destroy
        @workshop.destroy
        flash[:notice] = 'Le workshop a bien été supprimé'
        redirect_to workshops_path
    end

    private
        def set_workshop
            @workshop = Workshop.find params[:id]
        end

        def workshop_params
            params.require(:workshop).permit(:name)
        end
end
