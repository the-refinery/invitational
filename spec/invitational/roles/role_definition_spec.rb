require 'spec_helper'

describe Invitational do

  context "configured roles" do
    When {Invitational.define_roles :none, :admin}

    Then {Invitational::Role[:none].should == 0}
    And  {Invitational::Role[:admin].should == 1}
  end

  context "uberadmin role" do
    When {Invitational.define_roles :none, :admin}

    Then {Invitational::Role[:uberadmin].should == -1}
  end

end
