--F・HEROダイハードガル
function c101010091.initial_effect(c)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010091,1))
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,101010091)
	e2:SetTarget(c101010091.acttg)
	e2:SetOperation(c101010091.act)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	g:KeepAlive()
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101010091,2))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c101010091.sptg)
	e5:SetOperation(c101010091.spop)
	e5:SetLabelObject(g)
	c:RegisterEffect(e5)
	--spsummon
	if not c101010091.global_check then
		c101010091.global_check=true
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_TO_GRAVE)
		e4:SetOperation(c101010091.operation)
		Duel.RegisterEffect(e4,0)
		e4:SetLabelObject(g)
	end
end
function c101010091.dfilter(c,tp)
	return c:IsReason(REASON_DESTROY)
		and c:IsSetCard(0xf7a) and c:GetPreviousControler()==tp
end
function c101010091.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c101010091.dfilter,nil,tp)
	if g:GetCount()==0 then return end
	local sg=e:GetLabelObject()
	local c=e:GetHandler()
	if c:GetFlagEffect(101010091)==0 then
		sg:Clear()
		c:RegisterFlagEffect(101010091,RESET_EVENT+0x3fe0000+RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN,0,1)
	end
	sg:Merge(g)
end
function c101010091.filter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_DESTROY) and c:GetCode()~=101010091
end
function c101010091.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(101010091)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and e:GetLabelObject():IsExists(c101010091.filter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101010091,3))
	local g=e:GetLabelObject():FilterSelect(tp,c101010091.filter,1,1,nil)
	Duel.SetTargetCard(g)
end
function c101010091.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetTargetRange(LOCATION_SZONE,0)
		e2:SetCountLimit(1,101010091)
		e2:SetLabelObject(tc)
		e2:SetTarget(c101010091.tg)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c101010091.tg(e,c)
	return c~=e:GetLabelObject()
end
function c101010091.actfilter(c)
	return c:IsSetCard(0xf7a) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c101010091.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c101010091.actfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c101010091.act(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101010091,3))
	local g=Duel.SelectMatchingCard(tp,c101010091.actfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
		Duel.ConfirmCards(1-tp,g)
	end
end
c101010091.after=function(e,tp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c101010091.actfilter,tp,LOCATION_DECK,0,1,nil) end
	c101010091.act(e,tp)
end