using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Input;

namespace WpfApp
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void NumberValidationTextBox(object sender, TextCompositionEventArgs e)
        {
            var regex = new Regex("[^0-9]+");
            e.Handled = regex.IsMatch(e.Text);
        }

        private async void SendButton_Click(object sender, RoutedEventArgs e)
        {
            var num1 = int.Parse(textBox1.Text);
            var num2 = int.Parse(textBox2.Text);

            var client = new HttpClient();
            var values = new Dictionary<string, int>
            {
                { "x", num1 },
                { "y", num2 }
            };

            var json = JsonSerializer.Serialize(values);
            var content = new StringContent(json, Encoding.UTF8, "application/json");
            var response = await client.PostAsync($"https://localhost:7027/ddd.KNI/sum?x={num1}&y={num2}", content);
            var responseString = await response.Content.ReadAsStringAsync();
            resultTextBlock.Text =responseString;
        }

    }
}
