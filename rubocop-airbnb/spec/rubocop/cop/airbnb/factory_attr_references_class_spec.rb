describe RuboCop::Cop::Airbnb::FactoryAttrReferencesClass do
  subject(:cop) { described_class.new }

  it 'rejects with `attr_name CONST_NAME` in a factory' do
    source = [
      'factory :reservation2 do',
      '  status Reservation2::STATUS_NEW',
      'end',
    ].join("\n")
    inspect_source(source)

    expect(cop.offenses.size).to eq(1)
    expect(cop.offenses.map(&:line)).to eq([2])
  end

  it 'passes with `attr_name { CONST_NAME }` in a factory' do
    source = [
      'factory :reservation2 do',
      '  status { Reservation2::STATUS_NEW }',
      'end',
    ].join("\n")
    inspect_source(source)

    expect(cop.offenses).to be_empty
  end

  it 'rejects with `attr_name [CONST_NAME]`' do
    source = [
      'factory :reservation2 do',
      '  statuses [Reservation2::STATUS_NEW]',
      'end',
    ].join("\n")
    inspect_source(source)

    expect(cop.offenses.size).to eq(1)
    expect(cop.offenses.map(&:line)).to eq([2])
  end

  it 'passes with `attr_name { [CONST_NAME] }`' do
    source = [
      'factory :reservation2 do',
      '  statuses { [Reservation2::STATUS_NEW] }',
      'end',
    ].join("\n")
    inspect_source(source)

    expect(cop.offenses).to be_empty
  end

  it 'rejects with `attr_name [[CONST_NAME]]`' do
    source = [
      'factory :reservation2 do',
      '  statuses [[Reservation2::STATUS_NEW]]',
      'end',
    ].join("\n")
    inspect_source(source)

    expect(cop.offenses.size).to eq(1)
    expect(cop.offenses.map(&:line)).to eq([2])
  end

  it 'passes with `attr_name { [[CONST_NAME]] }`' do
    source = [
      'factory :reservation2 do',
      '  statuses { [[Reservation2::STATUS_NEW]] }',
      'end',
    ].join("\n")
    inspect_source(source)

    expect(cop.offenses).to be_empty
  end

  it 'rejects with `attr_name({ ConstName => something })' do
    source = [
      'factory :reservation2 do',
      '  status_names({ Reservation2::STATUS_NEW => "new" })',
      'end',
    ].join("\n")
    inspect_source(source)

    expect(cop.offenses.size).to eq(1)
    expect(cop.offenses.map(&:line)).to eq([2])
  end

  it 'passes with `attr_name { { ConstName => something } }`' do
    source = [
      'factory :reservation2 do',
      '  status_names { { Reservation2::STATUS_NEW => "new" } }',
      'end',
    ].join("\n")
    inspect_source(source)

    expect(cop.offenses).to be_empty
  end

  it 'rejects with `attr_name ConstName[:symbol]`' do
    source = [
      'factory :airlock_rule do',
      '  stickiness Airlock::STICKINESS[:user]',
      'end',
    ].join("\n")
    inspect_source(source)

    expect(cop.offenses.size).to eq(1)
    expect(cop.offenses.map(&:line)).to eq([2])
  end

  it 'passes with `attr_name { ConstName[:symbol] }`' do
    source = [
      'factory :airlock_rule do',
      '  stickiness { Airlock::STICKINESS[:user] }',
      'end',
    ].join("\n")
    inspect_source(source)

    expect(cop.offenses).to be_empty
  end

  it 'rejects even if the const is not the first attr' do
    source = [
      'factory :reservation2 do',
      '  trait :accepted do',
      '    cancel_policy Hosting::CANCEL_FLEXIBLE',
      '    status Reservation2::STATUS_NEW',
      '  end',
      'end',
    ].join("\n")
    inspect_source(source)

    expect(cop.offenses.size).to eq(2)
    expect(cop.offenses.map(&:line)).to eq([3, 4])
  end

  it 'rejects with `attr_name CONST_NAME` in a trait' do
    source = [
      'factory :reservation2 do',
      '  trait :accepted do',
      '    status Reservation2::STATUS_NEW',
      '  end',
      'end',
    ].join("\n")
    inspect_source(source)

    expect(cop.offenses.size).to eq(1)
    expect(cop.offenses.map(&:line)).to eq([3])
  end

  it 'passes with `attr_name { CONST_NAME }` in a trait' do
    source = [
      'factory :reservation2 do',
      '  trait :accepted do',
      '    status { Reservation2::STATUS_NEW }',
      '  end',
      'end',
    ].join("\n")
    inspect_source(source)

    expect(cop.offenses).to be_empty
  end
end
