class Account::StudentsController < InheritedResources::Base
  actions :all, except: [:show]
  before_action :authenticate_user!

  private

  def begin_of_association_chain
    current_user
  end
end