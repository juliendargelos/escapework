class AnswersController < ApplicationController
    before_action :authorize
    before_action :set_problem

    def update
        @answer = Answer.for @problem, current_user
        unless @answer.nil?
            if @answer.update answer_params
                redirect_to problem_path(@problem)
            else
                flash[:error] = 'Impossible d\'enregistrer la réponse'
                redirect_to problem_path(@problem)
            end
        else
            flash[:error] = 'Vous ne participez pas à ce workshop'
            redirect_to root_path
        end
    end

    private
        def set_problem
            @problem = Problem.find params[:problem_id]
        end

        def answer_params
            params.require(:answer).permit(:content)
        end
end
