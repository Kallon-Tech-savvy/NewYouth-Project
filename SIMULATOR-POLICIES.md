# Affordability and Savings Simulator Policies

## 1. Purpose and limits

The simulator helps users explore household affordability, savings, inflation, and future purchasing power. It is an educational scenario tool, not a guarantee of financial outcomes or a substitute for individualized financial advice.

Clearly distinguish observed data from defaults, user inputs, and hypothetical assumptions.

## 2. Reference income

Use an evidence-based primary reference-income benchmark derived from pilot household data. Compare lower- and higher-income scenarios where supported.

Disclose where the primary reference sits within the observed income distribution. Allow users to enter their own income in the personal simulator.

Do not invent a reference-income value before sufficient evidence is available.

## 3. Irregular income

Use a monthly-equivalent income for the standard benchmark. Where pilot data supports it, show typical-income, low-income, and variable-income scenarios. Explain that a monthly equivalent may hide cash-flow timing problems.

## 4. Remittances

Keep remittances separate in the data model from other income/resources. Let users include them in available household resources.

Support scenarios for regular remittances, irregular remittances, reduced remittances, and stopped remittances where useful. Distinguish money already received from expected future transfers.

## 5. Debt repayments

Model debt repayments as a separate expense category and subtract them from available resources. Allow affordability comparisons with and without repayments.

The initial simulator is not a full debt-management product.

## 6. Emergency expenses and reserves

Allow users to set an emergency-reserve target and calculate the amount needed to reach it, including per-week or per-month contributions and a target timeframe.

Account for any modeled surplus and warn when the target is unrealistic under the current assumptions.

Show total savings and emergency reserves separately. The reserve is part of total savings, not additional savings. Distinguish funds reserved for emergencies from funds available for other goals, and prevent double-counting.

## 7. Deficits and adjustment guidance

When a scenario has a deficit:

- Display the shortfall clearly.
- Preserve the original scenario.
- Offer interactive alternatives to explore reducing the deficit.
- Distinguish essential expenses from potentially adjustable expenses.
- Quantify the modeled impact of potential changes.
- Let the user decide what is realistic.

Never silently reduce an expense or increase income on the user's behalf.

## 8. Savings feasibility

Separate mathematical savings projections from budget feasibility. Show whether the modeled contributions fit the scenario's available budget and disclose practical uncertainties. Do not imply that a mathematically valid projection proves a household can consistently make the contributions.

## 9. Inflation assumptions

Use the tracked essential-goods basket as the baseline inflation input when data quality is adequate. Show adjustable low, medium, and high scenarios as alternatives. Clearly distinguish the New Youth basket-based estimate from official inflation statistics.

Offer a simple overall inflation option. Advanced users may apply category-specific rates where sufficient evidence supports them.

If a category lacks adequate inflation data, use the overall rate by default and disclose the limitation. Let advanced users replace the fallback with a user-defined assumption. Clearly label observed rates versus fallback or user-defined assumptions and include the assumptions in exports and saved scenarios where those features exist.

## 10. Future purchasing power

**Confirmed policy:** Show both the projected savings balance and its estimated purchasing power in today's terms.

The interface should distinguish:

- Nominal projected balance
- Estimated purchasing power in today's terms
- Applied inflation assumption
- Projection period
- Return and contribution assumptions

These are estimates, not guarantees. Use consistent periods and documented calculation rules.

## 11. Investment returns

**Confirmed policy:** Use one predefined annual return assumption for standard projections. Allow an advanced user-defined override.

Implementation requirements:

- The predefined percentage is still to be selected and justified; do not invent it.
- Display the rate and explain that it is an assumption, not guaranteed earnings.
- Apply it consistently to comparable standard projections.
- Recalculate the nominal balance and inflation-adjusted purchasing power when the advanced override changes.
- Label advanced overrides as user-defined assumptions.
- Do not imply that a positive return is guaranteed or risk-free.

A future decision is still needed on how the simulator handles negative returns and whether to provide downside scenarios. Do not assume a policy for that unanswered question.

## 12. Calculation transparency

Document the calculation method, timing conventions, compounding behavior, and rounding. Keep nominal and inflation-adjusted values mathematically consistent.

When comparing scenarios, vary only the intended inputs or make all changed inputs visible. Do not present scenario differences as observed causal effects.

## 13. Exports and saved scenarios

Where exports or saved scenarios are implemented, preserve the assumptions needed to interpret the result, including:

- Projection dates or duration
- Contribution amount and frequency
- Initial savings
- Applied return assumption and whether it is default or user-defined
- Inflation assumption and its source/type
- Relevant income and expense assumptions
- Any category-specific overrides
- Methodology/version information where applicable

Do not imply an export or save feature exists unless it is implemented.
