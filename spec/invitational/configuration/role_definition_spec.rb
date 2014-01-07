require 'spec_helper'

describe Invitational do

  context "configured roles" do
    Then {Invitational::Role[:none].should == 0}
    And  {Invitational::Role[:user].should == 1}
    And  {Invitational::Role[:admin].should == 2}
  end

  context "uberadmin role" do
    Then {Invitational::Role[:uberadmin].should == -1}
  end

end
