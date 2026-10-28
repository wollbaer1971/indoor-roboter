import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Comparator;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.xtext.diagnostics.Severity;
import org.eclipse.xtext.resource.IResourceServiceProvider;
import org.eclipse.xtext.util.CancelIndicator;
import org.eclipse.xtext.validation.CheckMode;
import org.eclipse.xtext.validation.IResourceValidator;
import org.omg.sysml.interactive.SysMLInteractive;

/** Batch validation with the official SysML v2 Pilot Implementation. */
public class ValidateModel {
    public static void main(String[] args) {
        if (args.length < 2 || args.length > 3) {
            System.err.println("Usage: ValidateModel.java <sysml.library> <model-directory> [--self-test]");
            System.exit(2);
        }
        var model = SysMLInteractive.getInstance();
        model.setVerbose(false);
        model.loadLibrary(Path.of(args[0]).toAbsolutePath().toString());
        model.readAll(Path.of(args[1]).toAbsolutePath().toString(), true, ".sysml");
        var resources = new ArrayList<Resource>(model.getInputResources());
        resources.sort(Comparator.comparing(r -> r.getURI().toString()));
        int errors = 0;
        int warnings = 0;
        // Load and index all resources before validation so filename order cannot
        // hide cross-file definitions or turn a forward reference into an error.
        for (var resource : resources) {
            var services = IResourceServiceProvider.Registry.INSTANCE
                .getResourceServiceProvider(resource.getURI());
            if (services == null) throw new IllegalStateException("No service for " + resource.getURI());
            var validator = services.get(IResourceValidator.class);
            for (var issue : validator.validate(resource, CheckMode.ALL, CancelIndicator.NullImpl)) {
                if (issue.getSeverity() == Severity.ERROR) errors++;
                if (issue.getSeverity() == Severity.WARNING) warnings++;
                System.out.printf("%s:%s:%s: %s: %s%n", resource.getURI().toFileString(),
                    issue.getLineNumber(), issue.getColumn(), issue.getSeverity(), issue.getMessage());
            }
        }
        System.out.printf("RESULT files=%d errors=%d warnings=%d%n", resources.size(), errors, warnings);
        if (errors == 0 && args.length == 3 && "--self-test".equals(args[2])) {
            String[][] fixtures = {
                {"syntheticPass", "pass"},
                {"syntheticFail", "fail"},
                {"syntheticIncomplete", "inconclusive"},
                {"syntheticNoCorridor", "fail"},
                {"syntheticNoDoor", "fail"},
                {"syntheticManualDriving", "fail"},
                {"syntheticMissingEvidence", "inconclusive"}
            };
            for (var fixture : fixtures) {
                String result = model.eval("MobileMaterialRobot_ModelChecks_A1::"
                    + fixture[0] + ".verdict", null).trim();
                System.out.printf("EVALUATION %s -> %s (expected %s)%n", fixture[0], result, fixture[1]);
                if (!result.matches("EnumerationUsage " + fixture[1] + " \\(.*\\)")) errors++;
            }
        }
        // Project quality gate: a type-binding warning must also fail CI.
        System.exit(errors == 0 && warnings == 0 ? 0 : 1);
    }
}
