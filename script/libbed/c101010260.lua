--During your Standby Phase: You can reveal this card in your hand until the end of the turn; destroy a number of cards your opponent controls, up to the number of "Radiant" monsters that are revealed in your hand. You can only use the effect of "Radiant Devil" once per turn. All LIGHT monsters you control gain 200 ATK for each LIGHT monster that is revealed in your hand.
--炯然デビル
local id,ref=GIR()
function ref.start(c)
--reveal
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101010182)
	e1:SetCondition(ref.condition)
	e1:SetCost(ref.cost)
	e1:SetTarget(ref.tg)
	e1:SetOperation(ref.op)
	c:RegisterEffect(e1)
	--boost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_HAND)
	e0:SetTargetRange(LOCATION_ONFIELD,0)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetCondition(ref.atkcon)
	e0:SetTarget(function(e,c) return c:IsAttribute(ATTRIBUTE_LIGHT) end)
	e0:SetValue(ref.atkval)
	c:RegisterEffect(e0)
end
function ref.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function ref.radfilter(c)
	return c:IsSetCard(0x5e) and c:IsPublic()
end
function ref.desfilter(c)
	return c:IsDestructable()
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(ref.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(ref.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(ref.radfilter,tp,LOCATION_HAND,0,nil)
	local g=Duel.GetMatchingGroup(ref.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if ct>0 and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,1,ct,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function ref.atkcon(e)
	return e:GetHandler():IsPublic()
end
function ref.rfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsPublic()
end
function ref.atkval(e)
	return Duel.GetMatchingGroupCount(ref.rfilter,e:GetHandlerPlayer(),LOCATION_HAND,0,nil)*200
end
