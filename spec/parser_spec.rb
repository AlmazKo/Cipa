# coding: utf-8
$:.unshift(File.dirname(__FILE__))

require "helper"
require "/home/almazko/projects/Cipa/lib/parser"

describe Cipa::Parser do
  before(:all) do
    @response = IO.read '/home/almazko/projects/Cipa/spec/temp'
    @expected_proposal ={
        id: 8455478,
        address: 'Ракетный бульвар д.7',
        rooms: 1,
        area: {
            kitchen: 6,
            living: 21,
            total: 32
        },
        photo: true,
        payment: 32_000,
        offer: {
            commission: 80,
            prepayments: '1 мес + страховой депозит'
        },
        flor: 8,
        info: ["Сдается 1-комн.кв. рядом с метро ВДНХ,чистый подьезд ( после ремонта),стеклопакеты, застекленный балкон, душевая кабина,вся необходимая мебель, на длительный срок ,т.89036144771"],
        additional: ['кух.мебель',
                     'жил.мебель',
                     'телефон',
                     'ТВ',
                     'стир.машина',
                     'холодильник',
                     'балкон',
                     'можно с животными',
                     'можно с детьми'
        ],
        realtor: {
            type: 'частный маклер',
            contact: '(916)124-0011',
            trust: 'участник акции'
        },
        date: DateTime.new(2012,8,31,16,03),
        #date: DateTime.new('21.08.2012 12:32')
    }

    @parser = Cipa::Parser.new
    @result = @parser.parse_search @response
  end

  it 'Из файла temp должен получиться массив из двух элементов' do
    @result.should have(2).elements
  end


  it 'В первом элементе должен быть id' do
    @result[0].should include(:id)
  end

  it 'В первом элементе должен быть правильный адрес' do
    @result[0].should include(:address)
    @result[0][:address].should eq @expected_proposal[:address]
  end

  it 'В первом элементе должен быть правильное количество комнат' do
    @result[0].should include(:rooms)
    @result[0][:rooms].should eq @expected_proposal[:rooms]
  end

  it 'В первом элементе должен быть правильно указана площадь комнат' do
    @result[0].should include(:area)
    @result[0][:area].should eq @expected_proposal[:area]
  end

  it 'В первом элементе должен быть правильно указана стоимость квартиры' do
    @result[0].should include(:payment)
    @result[0][:payment].should eq @expected_proposal[:payment]
  end

  it 'В первом элементе должен быть правильно указана дата объявления' do
    @result[0].should include(:date)
    @result[0][:date].should eq @expected_proposal[:date]
  end

  it 'В первом элементе должен быть правильно указано описание квартиры' do
    @result[0].should include(:info)
    @result[0][:info].should eq @expected_proposal[:info]

  end

  it 'В первом элементе должен быть правильно указано информация о фото' do
    @result[0][:photo].should eq @expected_proposal[:photo]
  end


end