import React from 'react'
import { VictoryPie, VictoryLabel } from 'victory'


const formatter = new Intl.NumberFormat('en-US', {
  style: 'currency',
  currency: 'USD',
  minimumFractionDigits: 2,
});

const asCurrency = (value, multiplier = 0.010) => (
  formatter.format(value * multiplier)
)

const ExpenseChart = ({ expenseTotal, data }) => {
  const colors = ["#3b457f", "#329087", "#9e9e9e"]
  const chartDimensions = 300

  return (
    <div className="chart-container">
      <div className="chart">
        <svg viewBox={`0 0 ${chartDimensions} ${chartDimensions}`}>
          <VictoryPie
            width={chartDimensions}
            height={chartDimensions}
            standalone={false}
            data={data}
            padAngle={3}
            innerRadius={55}
            labelRadius={65}
            labels={() => null}
            colorScale={colors}
          />
          <VictoryLabel
            textAnchor="middle"
            style={{ fontSize: 16, fill: "#3a867f", fontFamily: 'Open Sans' }}
            x={150} y={150}
            text={expenseTotal}
          />
        </svg>
      </div>
      <table className="legend">
        <tbody>

          {data.map((d, i) => (
            <tr key={d.x}>
              <td className="swatch" style={{backgroundColor: `${colors[i]}`}} />
              <td className="label">{d.x}</td>
              <td className="value currency">{asCurrency(d.y)}</td>
            </tr>
          ))}

        </tbody>
      </table>
    </div>
  )
}

export default ExpenseChart
