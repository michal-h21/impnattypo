require 'pdf/reader'

describe 'Impnattypo PDF' do
  reader = PDF::Reader.new('impnattypo-fr.pdf')
  it 'should have 13 pages' do
    reader.page_count.should eq(13)
  end
  it 'should be made by TeX' do
    reader.info[:Creator].should eq('TeX')
  end
  it 'should have page 1 with given media box' do
    reader.pages[0].attributes[:MediaBox].should eq([0, 0, 612, 792])
  end
  it 'should have 5 fonts on page 2' do
    reader.pages[1].fonts.keys.size.should eq(5)
  end
  it 'should start with a title' do
    reader.pages[0].text.should match('impnattypo')
  end
end
