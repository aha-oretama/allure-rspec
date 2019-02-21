steps_for :step_calling do
  step 'visible callee' do
    @testing = 123
  end

  step 'a visible step call' do
    step 'visible callee'
    @testing.should eq(123)
  end

  step 'visible failed callee' do
    @testing = 123
    @testing.should eq(321)
  end

  step 'a visible failed step call' do
    step 'visible failed callee'
  end

  step 'an invisible step call' do
    step 'aaa this is an unimplemented step'
  end

  step 'a global step call' do
    step 'there is a monster'
    @monster.should == 1
  end

  step 'an included call' do
    step 'an auto-loaded step is available'
  end
end
