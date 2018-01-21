require 'spec_helper'

describe 'Guard::Interactor::RELOAD' do

  before do
    allow(Guard).to receive(:reload)
    allow(Guard).to receive(:setup_interactor)
    allow(Pry.output).to receive(:puts)
    stub_const 'Guard::Bar', Class.new(Guard::Guard)
  end

  let(:guard)     { ::Guard.setup }
  let(:foo_group) { guard.add_group(:foo) }
  let(:bar_guard) { guard.add_guard(:bar, [], [], { :group => :foo }) }

  describe '#perform' do
    context 'without scope' do
      it 'runs the :reload action' do
        expect(Guard).to receive(:reload).with({ :groups => [], :plugins => [] })
        Pry.run_command 'reload'
      end
    end

    context 'with a valid Guard group scope' do
      it 'runs the :reload action with the given scope' do
        expect(Guard).to receive(:reload).with({ :groups => [foo_group], :plugins => [] })
        Pry.run_command 'reload foo'
      end
    end

    context 'with a valid Guard plugin scope' do
      it 'runs the :reload action with the given scope' do
        expect(Guard).to receive(:reload).with({ :plugins => [bar_guard], :groups => [] })
        Pry.run_command 'reload bar'
      end
    end

    context 'with an invalid scope' do
      it 'does not run the action' do
        expect(Guard).not_to receive(:reload)
        Pry.run_command 'reload baz'
      end
    end
  end
end
