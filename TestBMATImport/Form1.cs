using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Metrica.Common.BusinessObjects;

namespace TestBMATImport
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string[] lines = textBox1.Lines;
            foreach (string line in lines)
            {
                string[] data = line.Split(new Char[]{','});

                string code = data[0];

                Assignment assignment = new Assignment();
                

                string testInstanceId = assignment.SuspendData;

                if (string.IsNullOrEmpty(testInstanceId))
                {
                    //testInstanceId = Guid.NewGuid().ToString();
                    long newTestInstanceId = -1;
                    TestInstance testInstance = new TestInstance();
                    //testInstance.TestInstanceId = testInstanceId;
                    testInstance.TestId = "TSALeiden2014Placeholder";
                    testInstance.UserId = assignment.UserId;
                    testInstance.WhenStarted = DateTime.UtcNow;
                    testInstance.WhenSubmitted = DateTime.UtcNow;
                    testInstance.AssignmentId = assignment.AssignmentId;

                    //testInstance.Insert(out newTestInstanceId);
                    testInstance.Insert();
                    assignment.Update();
                    //testInstance.TestInstanceId = newTestInstanceId;
                    //assignment.SuspendData = newTestInstanceId.ToString();
                    assignment.SuspendData = testInstance.TestInstanceId.ToString();
                }
                Aggregation.Delete(Convert.ToInt64(testInstanceId));

                int i = 1;
                int order = 1;
                while (i < data.Length)
                {
                    Aggregation aggregation = new Aggregation();
                    aggregation.TestInstanceId = Convert.ToInt64(testInstanceId);
                    aggregation.AggregationId = Guid.NewGuid().ToString();
                    aggregation.Name = data[i];
                    aggregation.Value = data[i + 1];
                    aggregation.Order = order;
                    order++;
                    aggregation.Insert();

                    i = i + 2;
                }
            }
        }
    }
}
