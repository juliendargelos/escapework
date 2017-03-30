class ProblemsController < ApplicationController
    before_action authorize
    before_action only: [:new, :edit, :create, :update, :destroy] { authorize :teacher }

    before_action :set_workshop, only: [:index, :new, :create]
    before_action :set_problem, only: [:show, :edit, :update, :destroy]

    def index
        @problems = @workshop.problems
    end

    def show
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
            redirect_to problems_path(workshop_id: @workshop.id)
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
        redirect_to problems_path(workshop_id: @problem.workshop.id)
    end

    private
        def set_workshop
            @workshop = Workshop.find params[:workshop_id]
        end

        def set_problem
            @problem = Problem.find params[:id]
        end

        def problem_params
            params.require(:problem).permit(:content, :solution, :kind)
        end
end
