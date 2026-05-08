$jobTitles = @( 'General Manager','Senior Manager','Director','Junior Staff','Senior Staff' )
$surnames = @( 'Anderson','Armstrong','Bell','Bennett','Carter','Castillo','Dawson','Delgado','Emerson','Evans','Foster','Franklin','Garcia','Gutierrez','Harper','Hayes','Iglesias','Inoue','Jackson','Johnson','Kim','Knight','Lawson','Lopez','Martinez','Montgomery','Nakamura','Navarro','O''Connor','Owens','Parker','Patel','Quinn','Ramirez','Rodriguez','Sanders','Smith','Takahashi','Torres','Underwood','Upton','Valencia','Vasquez','Walker','Webb','Xu','Yamada','Young','Zhao','Ziegler' )
$givenNames = @( 'Aaron','Abigail','Adam','Alan','Albert','Alexande','Alexis','Alice','Amanda','Amber','Amy','Andrea','Andrew','Angela','Ann','Anna','Anthony','Arthur','Ashley','Austin','Barbara','Benjamin','Betty','Beverly','Billy','Bobby','Bradley','Brandon','Brenda','Brian','Brittany','Bruce','Bryan','Caleb','Carl','Carol','Carolyn','Catherine','Charles','Charlotte','Cheryl','Christian','Christina','Christine','Christopher','Cynthia','Daniel','Danielle','David','Deborah','Debra','Denise','Dennis','Diana','Diane','Donald','Donna','Dorothy','Douglas','Dylan','Edward','Elijah','Elizabeth','Emily','Emma','Eric','Ethan','Evelyn','Frances','Frank','Gabriel','Gary','George','Gerald','Gloria','Grace','Gregory','Hannah','Harold','Heather','Helen','Henry','Isaac','Isabella','Jack','Jacob','Jacqueline','James','Janet','Janice','Jason','Jean','Jeffrey','Jennifer','Jeremy','Jerry','Jesse','Jessica','Joan','Joe','John','Jonathan','Jordan','Jose','Joseph','Joshua','Joyce','Juan','Judith','Judy','Julia','Julie','Justin','Karen','Katherine','Kathleen','Kathryn','Kathy','Kayla','Keith','Kelly','Kenneth','Kevin','Kimberly','Kyle','Larry','Laura','Lauren','Lawrence','Liam','Linda','Lisa','Logan','Lori','Lucas','Luke','Madison','Margaret','Maria','Marilyn','Mark','Martha','Mary','Mason','Matthew','Megan','Melissa','Michael','Michelle','Nancy','Natalie','Nathan','Nicholas','Nicole','Noah','Olivia','Pamela','Patricia','Patrick','Paul','Peter','Rachel','Randy','Raymond','Rebecca','Richard','Robert','Roger','Ronald','Ruth','Ryan','Samantha','Samuel','Sandra','Sara','Sarah','Scott','Sean','Sharon','Shirley','Sophia','Stephanie','Stephen','Steven','Susan','Teresa','Terry','Theresa','Thomas','Tiffany','Timothy','Tyler','Victoria','Vincent','Virginia','Walter','Wayne','William','Willie','Zachary' )
$departments = @( 'Executive Management','Finance & Accounting','Human Resources (HR)','Marketing & Communications','Sales & Business Development','Customer Support & Service','Product Development','Research & Development (R&D)','Information Technology (IT)','Operations & Supply Chain','Legal & Compliance','Risk Management','Public Relations (PR)','Facilities & Administration','Corporate Social Responsibility (CSR)','Engineering & Manufacturing','Procurement & Vendor Management','Training & Development','Quality Assurance (QA)','Data Analytics & Business Intelligence' )
$departmentInfo = @{
    'Executive Management' = 'Oversees company strategy and leadership.';
    'Finance & Accounting' = 'Manages budgeting, financial reporting, and investments.';
    'Human Resources (HR)' = 'Handles recruitment, employee relations, and benefits.';
    'Marketing & Communications' = 'Focuses on branding, advertising, and customer engagement.';
    'Sales & Business Development' = 'Drives revenue growth and client relationships.';
    'Customer Support & Service' = 'Provides assistance and solutions for customers.';
    'Product Development' = 'Innovates and designs new products or services.';
    'Research & Development (R&D)' = 'Explores new technologies and ideas.';
    'Information Technology (IT)' = 'Maintains technical infrastructure and cybersecurity.';
    'Operations & Supply Chain' = 'Manages logistics, production, and inventory.';
    'Legal & Compliance' = 'Ensures regulatory and ethical standards are met.';
    'Risk Management' = 'Identifies and mitigates potential threats to the company.';
    'Public Relations (PR)' = 'Handles media relations and corporate messaging.';
    'Facilities & Administration' = 'Manages office spaces, security, and administrative tasks.';
    'Corporate Social Responsibility (CSR)' = 'Focuses on sustainability and ethical initiatives.';
    'Engineering & Manufacturing' = 'Oversees technical and production processes.';
    'Procurement & Vendor Management' = 'Handles purchasing and supplier relationships.';
    'Training & Development' = 'Provides employee learning and career growth opportunities.';
    'Quality Assurance (QA)' = 'Ensures products and services meet industry standards.';
    'Data Analytics & Business Intelligence' = 'Provides insights based on data trends.'
}

function New-RandomPassword {
    param(
        [ValidateRange(8,256)]
        [int]
        $Length = 32
    )
    $bytes = [System.Byte[]]::CreateInstance( [System.Byte], $Length )
    [System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes( $bytes )
    $bytes = $bytes | ForEach-Object { ( $_ % 93 ) + 33 }
    [System.Text.Encoding]::ASCII.GetString( $bytes )
}

$toCreate = Read-Host "How many users do you want to create? [8]"
if( $toCreate ) {

} else {
    $toCreate = 8
}
$platform = Read-Host "What platform are we targeting? [AD]"
if( $platform ) {

} else {
    $platform = 'AD'
}
$areaCode = Read-Host "What is the area code for your user's telephone numbers? [212]"
if( $areaCode ) { 

} else {
    $areaCode = '212'
}

$cursor = 0
$created = 0
$randos = [System.Byte[]]::CreateInstance( [System.Byte], $toCreate * 8 )
[System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes( $randos )
while( $created -lt $toCreate ) {

    $index = $randos[$cursor] * $randos[$cursor + 1]
    $jobTitle = $jobTitles[$index % ($jobTitles.Length)]

    $index = $randos[$cursor + 2] * $randos[$cursor + 3]
    $surname = $surnames[$index % ($surnames.Length)]

    $index = $randos[$cursor + 4] * $randos[$cursor + 5]
    $givenName = $givenNames[$index % ($givenNames.Length)]

    $index = $randos[$cursor + 6] * $randos[$cursor + 7]
    $department = $departments[$index % ($departments.Length)]

    Write-Output "User: $surname, $givenName ($jobTitle) $department"

    $cursor += 8
    $created += 1
}