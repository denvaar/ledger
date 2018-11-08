import React from 'react'
import ReactDOM from 'react-dom'

import ExpenseChart from './components/ExpenseChart'


const mapToChartData = (data) => (
  data.map(d => ({ color: d.color, x: d.budget, y: d.amount }))
)

ReactDOM.render(
  <ExpenseChart
    expenseTotal={expenseTotal}
    data={mapToChartData(expenseData)}
  />,
  document.getElementById('expense-chart')
)
