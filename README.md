## Stack Emissions Pollutant Levels for Regulatory Compliance

The company was preparing an Environmental Performance Report which aimed to show whether the company adhered to environmental regulations for the past years. This project focused on exploring and producing the best visual representation of the pollutant readings from the stack emissions of the company’s four power plant trains, Units 1, 2, 3, and 4. 

Traditionally, environmental performance reports are submitted as box plots. The script first analyzed the data using scatter plots, then explored box plots using various grouping of data (ie, per whole time range, per year, per quarter). The best plots which emphasized the company’s progressive improvement in 2017 while still showing noncompliances in previous years were achieved when data were plotted per year in 2015 and 2016, while per quarter in 2017. These mixed-period plots were proposed to management and were the only ones they found acceptable. 

### Data Scope

Measurements for the regulated pollutants are recorded daily. The source used in compiling the data are from PDF files of self-monitoring reports submitted to DENR, from 2nd quarter 2015 to 3rd quarter 2017. The company ceased in submitting daily data since 4th quarter 2017.

Most of the code used to clean and compile data from PDF files to the *Input* csv file were not included anymore in the published script as they were generated rapidly and without a clean structure.

### Pollutants

The regulated pollutants are Sulfur Oxides (SOx), Nitrogen Oxides (NOx), Carbon Monoxide (CO), and Particulate Matter (PM). Records are all in units of mg/Nm3 concentration. The following data were used for looping a single plotting code for all 4 pollutants:

Pollutant    | Reguatory Limits
-------------- | ----------------------
SOx             | 700 mg/Nm3
NOx            |1,000 mg/Nm3
CO               |500 mg/Nm3
PM              |150 mg/Nm3

## Analysis Process

1. **Scatter Plots for Exploratory Analysis**

Massive SOx and NOx outliers were submitted in the company's self-monitoring reports for 4th quarter 2015. Even though the magnitude indicate these are highly probable erroneous data, these data cannot be removed from the presentation as these were already submitted to regulatory bodies. Instead, the plots were bound using limits in the y-axes to avoid the outliers to squish the plots down.


Pollutant   | Y-Axis Limits
-------------- | ----------------------
SOx             | 1,500 mg/Nm3
NOx            |1,000 mg/Nm3
CO               |500 mg/Nm3
PM              |150 mg/Nm3

2. **Box Plots for whole Time frame**

Environmental performance charts are traditionally submitted as box plots. When a single box plot per emission source was plotted for the whole range of data, for SOx almost all values above the 3rd quartile of all Units exceed limits. These plots do not show that the company had been fully compliant since the last quarters of 2017.

3. **Box Plots per Year**

Even though box plots plotted per year already shows the great improvement of the company in following regulatory limits by year 2017, it did not show the progressive improvement within 2017 particularly in SOx for which 2017 box plots still have whiskers extending beyond the regulatory limits.

4. **Box Plots per Quarter**

Plotting per quarter highlights the effect of extreme outlier data for 2015 4th Quarter SOx values of all Units.

5. **Box Plots per mixed Period**

When data are plotted yearly in 2015 & 2016 and quarterly in 2017, almost all of the box plots now have whiskers below regulatory limits. The medians are also progressing downwards from 1Q to 3Q 2017. 

These are the final plots proposed to management and which they found acceptable.

