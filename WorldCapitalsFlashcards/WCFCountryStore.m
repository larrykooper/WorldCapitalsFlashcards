//
//  WCFCountryStore.m
//  WorldCapitalsFlashcards
//
//  Created by Kooper, Laurence on 6/28/13.
//  Copyright (c) 2013 Kooper, Laurence. All rights reserved.
//

#import "WCFCountryStore.h"
#import "Country.h"

@implementation WCFCountryStore

// Will initialize the store with all countries 
+ (WCFCountryStore *)sharedStore
{
    static WCFCountryStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self loadAllCountries];
    }
    return self;
}

- (NSArray *)allCountries
{
    return allCountries;
}

- (BOOL)loadAllCountries
{
    allCountries = [[NSMutableArray alloc] init];
    
    NSArray *countries =
    [NSArray arrayWithObjects:@"Afghanistan", @"Albania", @"Algeria", @"Andorra", @"Angola",
     @"Antigua and Barbuda", @"Argentina", @"Armenia", @"Australia", @"Austria",
     @"Azerbaijan", @"Bahamas", @"Bahrain", @"Bangladesh", @"Barbados",
     @"Belarus", @"Belgium", @"Belize", @"Benin", @"Bhutan",
     @"Bolivia", @"Bosnia and Herzegovina", @"Botswana", @"Brazil", @"Brunei",
     @"Bulgaria", @"Burkina Faso", @"Burundi", @"Cambodia", @"Cameroon",
     @"Canada", @"Cape Verde", @"Central African Republic", @"Chad", @"Chile",
     @"China", @"Colombia", @"Comoros", @"Democratic Rep.\nof the Congo", @"Republic of the Congo",
     @"Costa Rica", @"Croatia", @"Cuba", @"Cyprus", @"Czech Republic",
     @"Denmark", @"Djibouti", @"Dominican Republic", @"East Timor", @"Ecuador",
     @"Egypt", @"El Salvador", @"Equatorial Guinea", @"Eritrea", @"Estonia",
     @"Ethiopia", @"Fiji", @"Finland", @"France", @"Gabon",
     @"The Gambia", @"Georgia", @"Germany", @"Ghana", @"Greece",
     @"Grenada", @"Guatemala", @"Guinea", @"Guinea-Bissau", @"Guyana",
     @"Haiti", @"Honduras", @"Hungary", @"Iceland", @"India",
     @"Indonesia", @"Iran", @"Iraq", @"Ireland", @"Israel",
     @"Italy", @"Ivory Coast", @"Jamaica", @"Japan", @"Jordan",
     @"Kazakhstan", @"Kenya", @"Kiribati", @"North Korea", @"South Korea", @"Kosovo",
     @"Kuwait", @"Kyrgyzstan", @"Laos", @"Latvia", @"Lebanon",
     @"Lesotho", @"Liberia", @"Libya", @"Liechtenstein", @"Lithuania",
     @"Luxembourg", @"Macedonia", @"Madagascar", @"Malawi", @"Malaysia",
     @"Maldives", @"Mali", @"Malta", @"Marshall Islands", @"Mauritania",
     @"Mauritius", @"Mexico", @"Micronesia", @"Moldova", @"Monaco",
     @"Mongolia", @"Montenegro", @"Morocco", @"Mozambique", @"Myanmar",
     @"Namibia", @"Nauru", @"Nepal", @"Netherlands", @"New Zealand",
     @"Nicaragua", @"Niger", @"Nigeria", @"Norway", @"Oman",
     @"Pakistan", @"Palau", @"Palestine", @"Panama", @"Papua New Guinea",
     @"Paraguay", @"Peru", @"Philippines", @"Poland", @"Portugal",
     @"Qatar", @"Romania", @"Russia", @"Rwanda", @"Saint Kitts and Nevis",
     @"Saint Lucia", @"Saint Vincent\nand the Grenadines", @"Samoa", @"San Marino", @"Sao Tomé and Principe",
     @"Saudi Arabia", @"Senegal", @"Serbia", @"Seychelles", @"Sierra Leone",
     @"Singapore", @"Slovakia", @"Slovenia", @"Solomon Islands", @"Somalia",
     @"South Africa", @"South Sudan", @"Spain", @"Sri Lanka", @"Sudan",
     @"Suriname", @"Swaziland", @"Sweden", @"Switzerland", @"Syria", @"Taiwan",
     @"Tajikistan", @"Tanzania", @"Thailand", @"Togo", @"Tonga",
     @"Trinidad and Tobago", @"Tunisia", @"Turkey", @"Turkmenistan", @"Tuvalu",
     @"Uganda", @"Ukraine", @"United Arab Emirates", @"United Kingdom", @"United States",
     @"Uruguay", @"Uzbekistan", @"Vanuatu", @"Vatican City", @"Venezuela",
     @"Vietnam", @"Yemen", @"Zambia", @"Zimbabwe", nil];
    
    NSArray *capitals =
    [NSArray arrayWithObjects:@"Kabul", @"Tirana", @"Algiers", @"Andorra la Vella", @"Luanda",
    @"St. John's", @"Buenos Aires", @"Yerevan", @"Canberra", @"Vienna",
    @"Baku", @"Nassau", @"Manama", @"Dhaka", @"Bridgetown",
    @"Minsk", @"Brussels", @"Belmopan", @"Porto-Novo (official) /\n Cotonou (admin)", @"Thimphu",
    @"La Paz (admin) /\nSucre (official)", @"Sarajevo", @"Gaborone", @"Brasilia", @"Bandar Seri Begawan",
    @"Sofia", @"Ouagadougou", @"Bujumbura", @"Phnom Penh", @"Yaoundé",
    @"Ottawa", @"Praia", @"Bangui", @"N'Djamena", @"Santiago",
    @"Beijing", @"Bogotá", @"Moroni", @"Kinshasa", @"Brazzaville",
    @"San José", @"Zagreb", @"Havana", @"Nicosia", @"Prague",
    @"Copenhagen", @"Djibouti", @"Santo Domingo", @"Dili", @"Quito",
    @"Cairo", @"San Salvador", @"Malabo", @"Asmara", @"Tallinn",
    @"Addis Ababa", @"Suva", @"Helsinki", @"Paris", @"Libreville",
    @"Banjul", @"Tbilisi", @"Berlin", @"Accra", @"Athens",
    @"St. George's", @"Guatemala City", @"Conakry", @"Bissau", @"Georgetown",
    @"Port-au-Prince", @"Tegucigalpa", @"Budapest", @"Reykjavik", @"New Delhi",
    @"Jakarta", @"Tehran", @"Baghdad", @"Dublin", @"Jerusalem",
    @"Rome", @"Yamoussoukro", @"Kingston", @"Tokyo", @"Amman",
    @"Astana", @"Nairobi", @"Tarawa", @"Pyongyang", @"Seoul", @"Pristina",
    @"Kuwait City", @"Bishkek", @"Vientiane", @"Riga", @"Beirut",
    @"Maseru", @"Monrovia", @"Tripoli", @"Vaduz", @"Vilnius",
    @"Luxembourg City", @"Skopje", @"Antananarivo", @"Lilongwe", @"Kuala Lumpur",
    @"Malé", @"Bamako", @"Valletta", @"Majuro", @"Nouakchott",
    @"Port Louis", @"Mexico City", @"Palikir", @"Chisinau\n(kee-shee-now)", @"Monaco",
    @"Ulaanbaatar", @"Podgorica", @"Rabat", @"Maputo", @"Naypyidaw",
    @"Windhoek\n(VIND-hook)", @"Yaren District\n(de facto)", @"Kathmandu", @"Amsterdam", @"Wellington",
    @"Managua", @"Niamey\n(nee-AH-may)", @"Abuja", @"Oslo", @"Muscat",
    @"Islamabad", @"Ngerulmud\n(na-GRUL-mood)", @"Ramallah (de facto) /\nJerusalem (claimed)", @"Panama City", @"Port Moresby",
    @"Asunción", @"Lima", @"Manila", @"Warsaw", @"Lisbon",
    @"Doha", @"Bucharest", @"Moscow", @"Kigali", @"Basseterre",
    @"Castries", @"Kingstown", @"Apia (a-PEE-ah)", @"San Marino", @"Sao Tomé",
    @"Riyadh", @"Dakar", @"Belgrade", @"Victoria", @"Freetown",
    @"Singapore", @"Bratislava", @"Ljubljana\n(lyub-LYAN-a)", @"Honiara", @"Mogadishu",
    @"Pretoria (official) /\nCape Town (legis.) /\nBloemfontein (judicial)", @"Juba", @"Madrid", @"Colombo", @"Khartoum",
    @"Paramaribo\n(para-MARA-bow)", @"Mbabane", @"Stockholm", @"Bern", @"Damascus", @"Taipei",
    @"Dushanbe", @"Dodoma (official) /\nDar Es Salaam (admin)", @"Bangkok", @"Lomé", @"Nuku'alofa",
    @"Port of Spain", @"Tunis", @"Ankara", @"Ashgabat", @"Funafuti",
    @"Kampala", @"Kiev", @"Abu Dhabi", @"London", @"Washington",
    @"Montevideo", @"Tashkent", @"Port Vila", @"Vatican City", @"Caracas",
    @"Hanoi", @"Sana'a", @"Lusaka", @"Harare", nil];
    
    NSInteger capIndex = 0;
    for (NSString *country in countries) {
        Country *c = [[Country alloc] initWithName:country capital:[capitals objectAtIndex:capIndex]];
        capIndex++;
        [allCountries addObject:c];
    }
    [self setUpRemainingCards];
    
    return YES;    
}

- (void)setUpRemainingCards
{
    if (remainingCards) {
        remainingCards = nil;
    }
    
    // Copy allCountries into remainingCards
    remainingCards = [[NSMutableArray alloc] initWithArray:allCountries copyItems:YES];
}

- (void)removeCard:(Country *)country
{
    NSLog(@"Message 19: WCFCountryStore: We are in remove card with country %@", [country countryName]);
    [remainingCards removeObjectIdenticalTo:country];
}

- (Country *)getRandomCardFromRemaining
{
    NSUInteger randomIndex = arc4random() % [remainingCards count];
    return [remainingCards objectAtIndex:randomIndex];
}

- (NSInteger)numCardsRemaining
{
    return [remainingCards count];
}

- (NSInteger)numCardsTotal;
{
    return [allCountries count];
}

- (BOOL)cardDeckEmpty
{
    return ([self numCardsRemaining] == 0);
}

@end
