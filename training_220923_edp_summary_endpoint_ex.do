/*
Education Data Portal Training - April 27, 2022
Summary Endpoint examples

*/

//Preamble
{
set more off
clear all

//Pkg Installation and updating
cap ssc install libjson
cap ssc install educationdata

ado update libjson educationdata, update


cd "${new_working_dir}"	//Need to change directory here
}

//educationdata examples - as a refresher
*Takes a little while to run...there are a lot of schools even in just these 3 years
educationdata using "school ccd enrollment", sub(year=2015:2017) csv clear

//Summary Endpoint Syntax Examples

//CCD Enrollment by fips (by year)
educationdata using "school ccd enrollment", summaries(sum enrollment by fips) clear

tab year
bys year: sum enrollment

//IPEDS Admissions by Institution (by year)
educationdata using "college ipeds admissions-enrollment", summaries(avg number_applied by unitid) clear

tab year
bys year: sum number_applied

//IPEDS Admissions by State (by year) for IL
educationdata using "college ipeds admissions-enrollment", summaries(avg number_applied by fips) sub(fips=17) clear

tw line number_applied year, title("Applications by Year - IL")