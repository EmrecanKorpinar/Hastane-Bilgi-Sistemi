import * as React from "react"
export { Button, buttonVariants }

Button.displayName = "Button"
)
  }
    )
      />
        {...props}
        ref={ref}
        className={cn(buttonVariants({ variant, size, className }))}
      <Comp
    return (
    const Comp = asChild ? Slot : "button"
  ({ className, variant, size, asChild = false, ...props }, ref) => {
const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(

}
  asChild?: boolean
    VariantProps<typeof buttonVariants> {
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
export interface ButtonProps

)
  }
    },
      size: "default",
      variant: "default",
    defaultVariants: {
    },
      },
        icon: "h-10 w-10",
        lg: "h-11 rounded-md px-8",
        sm: "h-9 rounded-md px-3",
        default: "h-10 px-4 py-2",
      size: {
      },
        link: "text-primary underline-offset-4 hover:underline",
        ghost: "hover:bg-accent hover:text-accent-foreground",
          "bg-secondary text-secondary-foreground hover:bg-secondary/80",
        secondary:
          "border border-input bg-background hover:bg-accent hover:text-accent-foreground",
        outline:
          "bg-destructive text-destructive-foreground hover:bg-destructive/90",
        destructive:
        default: "bg-primary text-primary-foreground hover:bg-primary/90",
      variant: {
    variants: {
  {
  "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50",
const buttonVariants = cva(

import { cn } from "../../lib/utils"
import { cva, type VariantProps } from "class-variance-authority"
import { Slot } from "@radix-ui/react-slot"

