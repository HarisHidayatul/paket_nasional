*** Setting ***
# Library    SeleniumLibrary
Library    Selenium2Library
Library    RequestsLibrary
Library    Collections

#inisialisasi variable
Variables    init.py

*** Variables ***
${base_url}    http://127.0.0.1:8000
${url_sirup}    https://sirup.lkpp.go.id/sirup/ro/caripaket2

*** Keywords ***


*** Test Cases ***
Buka Browser Dan Lakukan Login
    Open Browser    ${url_sirup}    Edge
    Maximize Browser Window
    # Execute javascript       document.body.style.zoom="80%"
    # Sleep    3s

Mulai Lakukan Scarbbing Data
    Click element    xpath://*[@id="searchResult_length"]/label/select
    Click element    xpath://*[@id="searchResult_length"]/label/select/option[4]
    #pilih 100 baris
    FOR    ${infinityLoop}    IN RANGE    999999
        #Dapatkan nilai semua tabel
        Execute javascript       document.body.style.zoom="80%"
        Sleep    1s

        ${count_baris_tabel}    get element count    xpath://*[@id="searchResult"]/tbody/tr
        ${count_baris_tabel}=    Set Variable   ${count_baris_tabel + 1}
        FOR    ${index}    IN RANGE    1    ${count_baris_tabel}
            ${scroll_page}=    Set Variable   ${${count_baris_tabel} * ${index}}
            execute javascript    window.scrollTo(0,document.body.scrollHeight/(${scroll_page}))

            ${paket}    Get Text    xpath://*[@id="searchResult"]/tbody/tr[${index}]/td[2]/a
            ${pagu}    Get Text    xpath://*[@id="searchResult"]/tbody/tr[${index}]/td[3]/p
            ${pengadaan}    Get Text    xpath://*[@id="searchResult"]/tbody/tr[${index}]/td[4]
            ${produk}    Get Text    xpath://*[@id="searchResult"]/tbody/tr[${index}]/td[5]
            ${usaha}    Get Text    xpath://*[@id="searchResult"]/tbody/tr[${index}]/td[6]
            ${metode}   Get Text    xpath://*[@id="searchResult"]/tbody/tr[${index}]/td[7]
            ${pemilihan}    Get Text    xpath://*[@id="searchResult"]/tbody/tr[${index}]/td[8]
            ${klpd}    Get Text    xpath://*[@id="searchResult"]/tbody/tr[${index}]/td[9]
            ${satuan}    Get Text    xpath://*[@id="searchResult"]/tbody/tr[${index}]/td[10]
            ${lokasi}    Get Text    xpath://*[@id="searchResult"]/tbody/tr[${index}]/td[11]
            ${id_paket}    Get Text    xpath://*[@id="searchResult"]/tbody/tr[${index}]/td[12]

            create session    myssion    ${base_url}
            ${body}=    create dictionary    id_paket=${id_paket}    paket=${paket}    pagu=${pagu}    pengadaan=${pengadaan}    produk=${produk}    usaha=${usaha}    metode=${metode}    pemilihan=${pemilihan}    klpd=${klpd}    satuan=${satuan}    lokasi=${lokasi}
            ${header}=    create dictionary    Content-Type=application/json
            ${response}=    post request    myssion    /postPaketNasional    data=${body}    headers=${header}
            #validate data
            ${status_code}=    convert to string    ${response.status_code}
            should be equal    ${status_code}    200
        END
        #klik next
        Execute javascript       document.body.style.zoom="100%"
        execute javascript    window.scrollTo(0,document.body.scrollHeight)
        Wait Until Page Contains Element   xpath://*[@id="searchResult_next"]/a
        Wait Until Element Is Visible    xpath://*[@id="searchResult_next"]/a
        Sleep    1s 
        #This could be adjusted as per the time your application takes to load after first appearing. Usually this should be enough.
        Wait Until Element Is Visible    xpath://*[@id="searchResult_next"]/a
        Sleep    1s
        Wait Until Element Is Enabled    xpath://*[@id="searchResult_next"]/a
        Click Element    xpath://*[@id="searchResult_next"]/a
    END