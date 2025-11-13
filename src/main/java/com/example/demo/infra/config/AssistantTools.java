package com.example.demo.infra.config;

import dev.langchain4j.agent.tool.Tool;
import org.springframework.stereotype.Component;

@Component
public class AssistantTools {

    @Tool("Dá dicas rápidas de tarefas sustentáveis que o usuário pode fazer no dia a dia.")
    public String ecoTip(String area) {
        return switch (area.toLowerCase()) {
            case "casa" -> "Você pode economizar energia trocando lâmpadas comuns por LED e desligando aparelhos da tomada.";
            case "trabalho" -> "Leve sua própria garrafa reutilizável e evite o uso de copos descartáveis.";
            case "transporte" -> "Sempre que possível, opte por transporte público, bicicleta ou carona para reduzir a emissão de CO₂.";
            case "reciclagem" -> "Separe o lixo seco do orgânico e aprenda sobre a coleta seletiva na sua cidade.";
            default -> "Escolha uma área (ex: casa, trabalho, transporte, reciclagem) e eu te dou uma dica sustentável sobre isso!";
        };
    }

    @Tool("Calcula a economia de CO₂ estimada com base em quilômetros não percorridos de carro.")
    public String co2Saving(double km) {
        // em média, 1 km de carro emite ~0.2 kg de CO₂
        double savedCO2 = km * 0.2;
        return String.format("Evitando %.1f km de carro, você deixou de emitir cerca de %.2f kg de CO₂! 🌎", km, savedCO2);
    }

    @Tool("Explica o impacto ambiental de diferentes ações humanas.")
    public String environmentalImpact(String action) {
        return switch (action.toLowerCase()) {
            case "plantar árvore" -> "Plantar uma árvore ajuda a absorver CO₂ e melhorar a qualidade do ar. Uma árvore adulta pode absorver até 20 kg de CO₂ por ano.";
            case "usar energia solar" -> "Usar energia solar reduz a dependência de combustíveis fósseis e ajuda a combater o aquecimento global.";
            case "reciclar plástico" -> "Reciclar plástico economiza energia e reduz a poluição dos oceanos.";
            default -> "Essa ação ainda não está cadastrada, mas qualquer atitude que reduza o desperdício ou o consumo excessivo ajuda o planeta!";
        };
    }

}
