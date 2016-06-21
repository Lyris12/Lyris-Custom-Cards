--Number 24!: Cyber Dragon Truesdale "Kaiser"
local id,ref=GIR()
function ref.start(c)
--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),6,4)
	--continuous effects
	local aa=Effect.CreateEffect(c)
	aa:SetType(EFFECT_TYPE_FIELD)
	aa:SetRange(LOCATION_MZONE)
	aa:SetTargetRange(LOCATION_MZONE,0)
	aa:SetTarget(function(e,c) return c==e:GetHandler() end)
	aa:SetCode(EFFECT_ADD_ATTRIBUTE)
	aa:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(aa)
	local ar=Effect.CreateEffect(c)
	ar:SetType(EFFECT_TYPE_FIELD)
	ar:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	ar:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,0)
	ar:SetTarget(function(e,c) return c==e:GetHandler() end)
	ar:SetCode(EFFECT_ADD_RACE)
	ar:SetValue(RACE_DRAGON)
	c:RegisterEffect(ar)
	local sd=Effect.CreateEffect(c)
	sd:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	sd:SetCode(EVENT_SPSUMMON_SUCCESS)
	sd:SetCondition(ref.sdcon)
	sd:SetOperation(ref.sdop)
	c:RegisterEffect(sd)
	local cp=Effect.CreateEffect(c)
	cp:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	cp:SetCode(EVENT_ADJUST)
	cp:SetRange(LOCATION_MZONE)
	cp:SetOperation(ref.copy)
	c:RegisterEffect(cp)
	--detach
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(ref.cost)
	e2:SetTarget(ref.target)
	e2:SetOperation(ref.op)
	c:RegisterEffect(e2)
	--attach
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(ref.condition)
	e1:SetOperation(ref.operation)
	c:RegisterEffect(e1)
end
ref.xyz_number=24
function ref.sdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()~=LOCATION_EXTRA
end
function ref.sdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function ref.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,id)
end
function ref.cpfilter(c)
	return c:IsRace(RACE_MACHINE+RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and not c:IsType(TYPE_TUNER) and c:GetCode()~=id
end
function ref.copy(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local wg=Duel.GetMatchingGroup(ref.cpfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
	local wbc=wg:GetFirst()
	while wbc do
		local code=wbc:GetOriginalCode()
		if c:IsFaceup() and c:GetFlagEffect(code)==0 then
			c:CopyEffect(code,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,1)
			c:RegisterFlagEffect(code,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,0,1)
		end
		wbc=wg:GetNext()
	end
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayGroup():IsExists(Card.IsAbleToRemoveAsCost,1,nil) end
	local g=e:GetHandler():GetOverlayGroup():FilterSelect(tp,Card.IsAbleToRemoveAsCost,1,1,nil)
	Duel.Remove(g,0,REASON_COST)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	local atk=g:GetFirst():GetTextAttack()
	if atk<0 then atk=0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() then Duel.ConfirmCards(1-tp,tc) end
	if tc and tc:IsRelateToEffect(e) then
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		Duel.Damage(1-tp,atk,REASON_BATTLE)
		Duel.BreakEffect()
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.Overlay(c,Group.FromCards(og))
		end
		if not tc:IsType(TYPE_TOKEN) and tc:IsAbleToChangeControler() then
			Duel.Overlay(c,Group.FromCards(tc))
		end
	end
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,LOCATION_EXTRA)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			local tc=g:RandomSelect(tp,1)
			Duel.Overlay(c,tc)
		end
	end
end
