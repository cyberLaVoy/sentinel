library(shiny)
source(here::here("R", "utils.R"))

ui <- fluidPage(
    h2("GPU"),
    fluidRow(
        column(width = 2,
               h3("Core Temp. ( °C )"),
               textOutput("gpu_core_temp")),
        column(width = 2,
               h3("Memory Temp. ( °C )"),
               textOutput("gpu_memory_temp")),
        column(width = 2,
               h3("Power ( Watts )"),
               textOutput("gpu_power_usage")),
        column(width = 2,
               h3("VRAM Used ( GB )"),
               textOutput("gpu_vram_usage")),
        column(width = 2,
               h3("Fan ( % )"),
               textOutput("gpu_fan_perc"))
    ),
    h2("CPU"),
    fluidRow(
        column(width = 2,
               h3("Temp. ( °C )"),
               textOutput("cpu_temp")),
        column(width = 2,
               h3("Threads ( % )"),
               textOutput("cpu_thread_perc"))
    ),
    h2("RAM"),
    fluidRow(
        column(width = 2,
               h3("Used ( GB )"),
               textOutput("ram_usage"))
    )
)

server <- function(input, output, session) {


    # Define a reactive timer that updates the values every .5 seconds
    refresh_timer <- reactiveTimer(interval = 500)

    sensor_readings <- reactive({
        refresh_timer()

        readings <- list(
            # Get GPU core temperature
            gpu_core_temp = system("nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader", intern = TRUE),

            # Get GPU memory junction temperature
            gpu_memory_temp = system("nvidia-smi --query-gpu=temperature.memory --format=csv,noheader", intern = TRUE),

            # Get GPU power usage
            gpu_power_usage = system("nvidia-smi --query-gpu=power.draw --format=csv,noheader", intern = TRUE),

            # Get VRAM usage
            gpu_vram_usage = system("nvidia-smi --query-gpu=memory.used --format=csv,noheader | awk '{print $1/1000}'", intern = TRUE),

            # Get fan percentages
            gpu_fan_perc = system("nvidia-smi --query-gpu=fan.speed --format=csv,noheader", intern = TRUE),

            # Get CPU temperature
            cpu_temp = system("sensors | grep Composite | awk '{print $2}'", intern = TRUE),

            # Get CPU thread percentages
            cpu_thread_perc = system("top -b -n1 | grep 'Cpu(s)' | awk '{print $2 + $4}'", intern = TRUE),

            # Get RAM usage
            ram_usage = system("free | grep Mem | awk '{print $3/1000000}'", intern = TRUE)
        )

        readings <- remove_chars_and_convert_to_real_list(readings)
        return(readings)
    })


    output$gpu_core_temp <- renderText({
        sensor_readings()$gpu_core_temp
    })

    output$gpu_memory_temp <- renderText({
        sensor_readings()$gpu_memory_temp
    })

    output$gpu_power_usage <- renderText({
        sensor_readings()$gpu_power_usage
    })

    output$gpu_vram_usage <- renderText({
        sensor_readings()$gpu_vram_usage
    })

    output$gpu_fan_perc <- renderText({
        sensor_readings()$gpu_fan_perc
    })

    output$cpu_temp <- renderText({
        sensor_readings()$cpu_temp
    })

    output$cpu_thread_perc <- renderText({
        sensor_readings()$cpu_thread_perc
    })

    output$ram_usage <- renderText({
        sensor_readings()$ram_usage
    })

}

shinyApp(ui, server, options = list("host" = "0.0.0.0", port = 42069))
