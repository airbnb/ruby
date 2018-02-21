describe RuboCop::Cop::Airbnb::ClassName do
  subject(:cop) { described_class.new }

  describe "belongs_to" do
    it 'rejects with Model.name' do
      source = [
        'class Coupon',
        '  belongs_to :user, :class_name => User.name',
        'end',
      ].join("\n")
      inspect_source(source)

      expect(cop.offenses.size).to eq(1)
      expect(cop.offenses.map(&:line).sort).to eq([2])
    end

    it 'passes with "Model"' do
      source = [
        'class Coupon',
        '  belongs_to :user, :class_name => "User"',
        'end',
      ].join("\n")
      inspect_source(source)

      expect(cop.offenses).to be_empty
    end
  end

  describe "has_many" do
    it 'rejects with Model.name' do
      source = [
        'class Coupon',
        '  has_many :reservations, :class_name => Reservation2.name',
        'end',
      ].join("\n")
      inspect_source(source)

      expect(cop.offenses.size).to eq(1)
      expect(cop.offenses.map(&:line)).to eq([2])
    end

    it 'passes with "Model"' do
      source = [
        'class Coupon',
        '  has_many :reservations, :class_name => "Reservation2"',
        'end',
      ].join("\n")
      inspect_source(source)

      expect(cop.offenses).to be_empty
    end
  end

  describe "has_one" do
    it 'rejects with Model.name' do
      source = [
        'class Coupon',
        '  has_one :loss, :class_name => Payments::Loss.name',
        'end',
      ].join("\n")
      inspect_source(source)

      expect(cop.offenses.size).to eq(1)
      expect(cop.offenses.map(&:line)).to eq([2])
    end

    it 'passes with "Model"' do
      source = [
        'class Coupon',
        '  has_one :loss, :class_name => "Payments::Loss"',
        'end',
      ].join("\n")
      inspect_source(source)

      expect(cop.offenses).to be_empty
    end
  end
end
