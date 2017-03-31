class ProblemsController < ApplicationController
    before_action :authorize
    before_action only: [:new, :edit, :create, :update, :destroy] { authorize only: :teacher }

    before_action :set_workshop, only: [:new, :create]
    before_action :set_problem, only: [:show, :edit, :update, :destroy]

    def show
        if current_user.participates_to?(@problem.workshop) || current_user.teacher?
            @answer = Answer.for @problem, current_user
        else
            flash[:error] = 'Vous ne participez pas à ce workshop'
            redirect_to workshops_path
        end
    end

    def new
        @problem = Problem.new workshop: @workshop
    end

    def edit
    end

    def create
        @problem = Problem.new problem_params.merge(workshop: @workshop)

        if @problem.save
            flash[:success] = 'Le problème a bien été enregistré'
            redirect_to workshop_path(@workshop)
        else
            flash[:error] = 'Impossible d\'enregistrer le problème'
            render :new
        end
    end

    def update
        if @problem.update problem_params
            flash[:success] = 'Les modifications ont bien été enregistrées'
        else
            flash[:error] = 'Impossible d\'enregistrer les modifications'
        end

        render :edit
    end

    def destroy
        @problem.destroy
        flash[:notice] = 'Le problème a bien été supprimé'
        redirect_to workshop_path(@workshop)
    end

    private
        def set_workshop
            @workshop = Workshop.find params[:workshop_id]
        end

        def set_problem
            @problem = Problem.find params[:id]
        end

        def problem_params
            problem_params = params.require(:problem).permit(:name, :content, :solution, :kind, :image, :category)
            problem_params[:image] = nil if params[:delete_image] == '1'

            problem_params
        end
end
