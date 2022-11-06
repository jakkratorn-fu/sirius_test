*** Settings ***
Library    SeleniumLibrary
Library    String
Library    Collections
Test Setup      Set Selenium Timeout    30s
Test Teardown   Close All Browsers

*** Variables ***

*** Test Cases ***
Find Iphone In Shopee
    Open Shopee Website
    Select Thai Language
    Close Advertise
    Search For Product    iPhone
    Select Sort Price From Desc
    Validate Top 5 Items Sort By Price Correctly

*** Keywords ***
Open Shopee Website
    Open Browser    https://shopee.co.th/   chrome
    Set Window Size     1366    900

Select Thai Language
    Wait Until Element Is Visible   //button[contains(text(),'ไทย')]
    Click Button    //button[contains(text(),'ไทย')]

Close Advertise
    Wait Until Element Is Visible   //*[@class="home-page"]
    Click Element   //*[@class="home-page"]

Search For Product
    [Arguments]    ${search}
    Wait Until Element Is Visible   //input[@class="shopee-searchbar-input__input"]
    Input Text  //input[@class="shopee-searchbar-input__input"]     ${search}
    Click Element   //button[@class="btn btn-solid-primary btn--s btn--inline shopee-searchbar__search-button"]

Select Sort Price From Desc
    Wait Until Element Is Visible   class:select-with-status
    Mouse Over   class:select-with-status
    Wait Until Element Is Visible   //*[contains(text(),"ราคา: จากมากไปน้อย")]
    Click Element   //*[contains(text(),"ราคา: จากมากไปน้อย")]

Validate Top 5 Items Sort By Price Correctly
    Wait Until Element Is Visible   //*[@class="hpDKMN"]
    ${price_list}=  Create List
#    get top 5 price and save in list
    FOR    ${index}     IN RANGE    1   6
        ${price}=    Get Text    (//*[@class="hpDKMN"])[${index}]
        ${price}=    Remove String   ${price}     ฿   ,  ${SPACE}
        ${price}=   Replace String Using Regexp     ${price}    ${\n}   nl
        ${is_price_range}=  Evaluate    "-" in "${price}"
        ${is_discount_price}=   Evaluate    "nl" in "${price}"
#        check price range and get only min
        IF    ${is_price_range}
            ${prices}=   Split String    ${price}     -
            Append To List  ${price_list}   ${prices}[0]
#        check discount price and get only discounted price
        ELSE IF    ${is_discount_price}
            ${prices}=   Split String    ${price}     nl
            Append To List  ${price_list}   ${prices}[1]
        ELSE
            Append To List  ${price_list}   ${price}
        END
    END
#    check desc
    FOR    ${index}     IN RANGE    1   5
        ${index-1}=     Evaluate    ${index}-1
        ${status}=  Evaluate    ${price_list}[${index}]<=${price_list}[${index-1}]
        IF    ${status}==False
            Fail    The price are not descending sorted
        END
    END
